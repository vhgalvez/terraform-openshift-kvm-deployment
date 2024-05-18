# output.tf

output "ip_addresses" {
  value = { for key, machine in libvirt_domain.vm : key => machine.network_interface[0].addresses[0] if length(machine.network_interface[0].addresses) > 0 }
}
