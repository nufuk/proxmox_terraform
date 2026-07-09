variable "proxmox_api_url" {
    description = "Proxmox API URL"
    type = string
    sensitive = true  
}

variable "proxmox_api_token_id" {
    description = "API Token ID"
    type = string
    sensitive = true  
}

variable "proxmox_api_token_secret" {
  description = "API Token secret"
  type = string
  sensitive = true
}

variable "proxmox_node1" {
    description = "Proxmox node name"
    type = string
}

variable "proxmox_node2" {
    description = "Proxmox node name"
    type = string
}

variable "proxmox_node3" {
    description = "Proxmox node name"
    type = string
}

variable "vm_image_file_id" {
    description = "Storage ID dof the local vm image"
    type = string 
}

variable "container_template_file_id" {
    description = "LXC template file ID"
    type = string  
}

variable "ssh_public_key" {
    description = "SSH key for access to the VM/CT"
    type = string
    sensitive = true  
}
variable "ssh_private_key" {
    description = "SSH key for access to the VM/CT"
    type = string
    sensitive = true  
}