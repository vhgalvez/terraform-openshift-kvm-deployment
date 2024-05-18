# main.tf

resource "libvirt_volume" "vm_volume" {
  for_each = var.vm_rockylinux_definitions

  name   = each.value.volume_name
  pool   = each.value.volume_pool
  format = each.value.volume_format
  size   = each.value.volume_size
}

data "template_file" "user_data" {
  for_each = var.vm_rockylinux_definitions

  template = file("${path.module}/config/${each.key}-user-data.tpl")

  vars = {
    ssh_keys = join("\n  - ", var.ssh_keys),
    hostname = each.key,
    timezone = var.timezone,
  }
}

resource "libvirt_cloudinit_disk" "vm_cloudinit" {
  for_each = var.vm_rockylinux_definitions

  name      = "${each.key}_cloudinit.iso"
  pool      = each.value.cloudinit_pool
  user_data = data.template_file.user_data[each.key].rendered
}

resource "libvirt_domain" "vm" {
  for_each = var.vm_rockylinux_definitions

  name   = each.key
  memory = each.value.domain_memory
  vcpu   = each.value.cpus

  network_interface {
    network_name   = var.rocky9_network_name
    wait_for_lease = true
    addresses      = [each.value.ip] # Ensure IP assignment
  }

  disk {
    volume_id = libvirt_volume.vm_volume[each.key].id
  }

  cloudinit = libvirt_cloudinit_disk.vm_cloudinit[each.key].id

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "0"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }

  cpu {
    mode = "host-passthrough"
  }
}
