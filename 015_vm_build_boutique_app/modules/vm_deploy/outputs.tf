output "default_ip" {
  description = "VM default IP address"
  value       = vsphere_virtual_machine.vm.default_ip_address
}
