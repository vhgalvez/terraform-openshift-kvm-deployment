# nat_network_02/main.tf
resource "libvirt_network" "kube_network_02" {
  name      = "kube_network_02"
  mode      = "nat"
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

# Otras configuraciones específicas para nat_network_02

# Ejemplo de dominio
resource "libvirt_domain" "vm_nat_02" {
  name   = "freeipa1"
  memory = 2048
  vcpu   = 2

  network_interface {
    network_id     = libvirt_network.kube_network_02.id
    wait_for_lease = true
    addresses      = ["10.17.3.11"]
  }

  disk {
    volume_id = libvirt_volume.rocky9_image.id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }

  cloudinit = libvirt_cloudinit_disk.freeipa1.id
}
