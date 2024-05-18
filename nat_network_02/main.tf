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

resource "libvirt_network" "kube_network_02" {
  name      = var.rocky9_network_name
  mode      = "nat"
  addresses = ["10.17.3.0/24"]
}

resource "libvirt_pool" "volumetmp_kube_02" {
  name = "${var.cluster_name}_kube_02"
  type = "dir"
  path = "/var/lib/libvirt/images/${var.cluster_name}_kube_02"
}

resource "libvirt_volume" "rocky9_image" {
  name   = "${var.cluster_name}_kube_02-rocky9_image"
  source = var.rocky9_image
  pool   = libvirt_pool.volumetmp_kube_02.name
  format = "qcow2"
}

data "template_file" "vm-configs" {
  for_each = var.vm_rockylinux_definitions

  template = file("${path.module}/config/${each.key}-user-data.tpl")
  vars = {
    ssh_keys = jsonencode(var.ssh_keys)
    hostname = each.key
    timezone = var.timezone
  }
}

resource "libvirt_cloudinit_disk" "vm_cloudinit" {
  for_each = var.vm_rockylinux_definitions

  name      = "${each.key}_cloudinit.iso"
  pool      = libvirt_pool.volumetmp_kube_02.name
  user_data = data.template_file.vm-configs[each.key].rendered
}

resource "libvirt_volume" "vm_disk" {
  for_each = var.vm_rockylinux_definitions

  name           = "${each.key}-${var.cluster_name}.qcow2"
  base_volume_id = libvirt_volume.rocky9_image.id
  pool           = libvirt_pool.volumetmp_kube_02.name
  format         = "qcow2"
}

resource "libvirt_domain" "vm" {
  for_each = var.vm_rockylinux_definitions

  name   = each.key
  memory = each.value.domain_memory
  vcpu   = each.value.cpus

  network_interface {
    network_id     = libvirt_network.kube_network_02.id
    wait_for_lease = true
    addresses      = [each.value.ip]
  }

  disk {
    volume_id = libvirt_volume.vm_disk[each.key].id
  }

  cloudinit = libvirt_cloudinit_disk.vm_cloudinit[each.key].id

  graphics {
    type        = "vnc"
    listen_type = "address"
  }

  cpu {
    mode = "host-passthrough"
  }
}

