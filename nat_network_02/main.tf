terraform {
  required_version = ">= 0.13"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_network" "kube_network_02" {
  name      = "kube_network_02"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.3.0/24"]
}

resource "libvirt_pool" "volumetmp_nat_02" {
  name = "${var.cluster_name}_nat_02"
  type = "dir"
  path = "/var/lib/libvirt/images/${var.cluster_name}_nat_02"
}

resource "libvirt_volume" "rocky9_image" {
  name   = "${var.cluster_name}_rocky9_image"
  source = var.rocky9_image
  pool   = libvirt_pool.volumetmp_nat_02.name
  format = "qcow2"
}

data "template_file" "vm_configs" {
  for_each = var.vm_rockylinux_definitions

  template = file("${path.module}/config/${each.key}-user-data.tpl")
  vars = {
    ssh_keys = jsonencode(var.ssh_keys),
    hostname = each.value.hostname,
    timezone = var.timezone
  }
}

resource "libvirt_cloudinit_disk" "vm_cloudinit" {
  for_each = var.vm_rockylinux_definitions

  name           = "${each.key}_cloudinit.iso"
  pool           = libvirt_pool.volumetmp_nat_02.name
  user_data      = data.template_file.vm_configs[each.key].rendered
  network_config = templatefile("${path.module}/config/network-config.tpl", {
    ip      = each.value.ip,
    gateway = var.gateway,
    dns1    = var.dns1,
    dns2    = var.dns2
  })
}

resource "libvirt_volume" "vm_disk" {
  for_each = var.vm_rockylinux_definitions

  name           = "${each.key}-${var.cluster_name}.qcow2"
  base_volume_id = libvirt_volume
