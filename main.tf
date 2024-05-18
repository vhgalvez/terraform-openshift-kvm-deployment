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

module "bastion_network" {
  source = "./bastion_network"
}

module "nat_network_02" {
  source = "./nat_network_02"
}

module "nat_network_03" {
  source = "./nat_network_03"
}