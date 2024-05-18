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

# Otras configuraciones específicas para bastion_network

# Ejemplo de dominio
resource "libvirt_domain" "vm_bastion" {
  name   = "bastion1"
  memory = 2048
  vcpu   = 2

  network_interface {
    network_id = libvirt_network.br0.id
    bridge     = "br0"
  }

  disk {
    volume_id = libvirt_volume.rocky9_image.id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }

  cloudinit = libvirt_cloudinit_disk.bastion.id
}
