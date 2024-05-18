terraform {
  required_version = "= 1.8.3"
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

module "network_br0" {
  source                    = "./network_br0"
  cluster_name              = var.cluster_name
  rocky9_image              = var.rocky9_image
  ssh_keys                  = var.ssh_keys
  vm_rockylinux_definitions = var.vm_rockylinux_definitions_br0
}

module "network_kube_02" {
  source                    = "./network_kube_02"
  depends_on                = [module.network_br0]
  cluster_name              = var.cluster_name
  rocky9_image              = var.rocky9_image
  ssh_keys                  = var.ssh_keys
  vm_rockylinux_definitions = var.vm_rockylinux_definitions_kube_02
}

module "network_kube_03" {
  source         = "./network_kube_03"
  depends_on     = [module.network_kube_02]
  cluster_name   = var.cluster_name
  base_image     = var.base_image
  ssh_keys       = var.ssh_keys
  vm_definitions = var.vm_definitions_kube_03
}
