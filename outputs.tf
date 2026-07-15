output "vm1_ip" {
    value = proxmox_virtual_environment_vm.pve1_vm.ipv4_addresses[1][0]
}
output "vm2_ip" {
    value = proxmox_virtual_environment_vm.pve2_vm.ipv4_addresses[1][0]
}
output "vm3_ip" {
    value = proxmox_virtual_environment_vm.pve3_vm.ipv4_addresses[1][0]
}
