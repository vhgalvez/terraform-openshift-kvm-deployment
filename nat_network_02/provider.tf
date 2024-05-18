# provider.tf
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
