# bastion_network/main.tf

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_network" "br0" {
  name      = "br0"
  mode      = "bridge"
  bridge    = "br0"
  autostart = true
  addresses = ["192.168.0.0/24"]
}

resource "libvirt_pool" "volumetmp_bastion" {
  name = "${var.cluster_name}_bastion"
  type = "dir"
  path = "/var/lib/libvirt/images/${var.cluster_name}_bastion"
}

resource "libvirt_volume" "rocky9_image" {
  name   = "${var.cluster_name}_rocky9_image"
  source = var.rocky9_image
  pool   = libvirt_pool.volumetmp_bastion.name
  format = "qcow2"
}

data "template_file" "bastion_user_data" {
  template = file("${path.module}/config/bastion1-user-data.tpl")
  vars = {
    ssh_keys = jsonencode(var.ssh_keys)
    hostname = "bastion1"
  }
}

resource "libvirt_cloudinit_disk" "bastion" {
  name           = "bastion1-cloudinit.iso"
  pool           = libvirt_pool.volumetmp_bastion.name
  user_data      = data.template_file.bastion_user_data.rendered
  network_config = file("${path.module}/config/network-config.tpl")
}

resource "libvirt_volume" "vm_disk" {
  name           = "bastion1_volume.qcow2"
  base_volume_id = libvirt_volume.rocky9_image.id
  pool           = libvirt_pool.volumetmp_bastion.name
  format         = "qcow2"
  size           = "32212254720" # 30GB
}

resource "libvirt_domain" "vm_bastion" {
  name   = "bastion1"
  memory = 2048
  vcpu   = 2

  network_interface {
    network_id = libvirt_network.br0.id
    bridge     = "br0"
  }

  disk {
    volume_id = libvirt_volume.vm_disk.id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }

  cloudinit = libvirt_cloudinit_disk.bastion.id
}

output "bastion_ip_address" {
  value = libvirt_domain.vm_bastion.network_interface[0].addresses[0]
}
