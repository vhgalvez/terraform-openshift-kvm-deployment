# output.tf

output "ip_addresses" {
  value = { 
    for key, vm in libvirt_domain.vm : 
      key => length(vm.network_interface[0].addresses) > 0 ? vm.network_interface[0].addresses[0] : "No IP Assigned"
  }
}
