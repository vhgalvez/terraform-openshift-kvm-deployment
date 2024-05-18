terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.10.0"
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

resource "libvirt_network" "kube_network_03" {
  name      = "kube_network_03"
  mode      = "nat"
  addresses = ["10.17.4.0/24"]
}

resource "libvirt_pool" "volumetmp_nat_03" {
  name = "${var.cluster_name}_nat_03"
  type = "dir"
  path = "/var/lib/libvirt/images/${var.cluster_name}_nat_03"
}

resource "libvirt_volume" "base" {
  name   = "${var.cluster_name}_base"
  source = var.base_image
  pool   = libvirt_pool.volumetmp_nat_03.name
  format = "qcow2"
}

# Otras configuraciones específicas para nat_network_03

# Ejemplo de dominio
resource "libvirt_domain" "vm_nat_03" {
  name   = "bootstrap1"
  memory = 1024
  vcpu   = 1

  network_interface {
    network_id     = libvirt_network.kube_network_03.id
    wait_for_lease = true
    addresses      = ["10.17.4.20"]
  }

  disk {
    volume_id = libvirt_volume.base.id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }

  coreos_ignition = libvirt_ignition.bootstrap1.id
}
