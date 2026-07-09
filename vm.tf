resource "proxmox_virtual_environment_vm" "pve1_vm" {
    name = "k8-control-plane"
    description = "Open Tofu created VM"
    node_name = var.proxmox_node1
    vm_id = 100
    tags = ["tofu", "rocky", "vm", "k8_control_plane"]
    stop_on_destroy = true

    cpu {
        cores = 1
        type = "host"
    }

    memory {
        dedicated = 2048
    }

    disk {
        datastore_id = "local-lvm"
        import_from = var.vm_image_file_id
        interface = "virtio0"
        size = 10
    }

    network_device {
        bridge = "vmbr0"
        model = "virtio"
    }

    agent {
        enabled = true
    }

    operating_system {
        type = "l26"
    }

    initialization {
        ip_config {
            ipv4 {
                address = "192.168.1.10/24"
                gateway = "192.168.1.1"
            }
        }
        user_account {
            keys = [
                trimspace(tls_private_key.vm_key.public_key_openssh), 
                var.ssh_public_key,
                trimspace(tls_private_key.container_key.public_key_openssh)]
            password = random_password.vm_password.result
            username = "nufuk"
        }
    }
}

resource "proxmox_virtual_environment_vm" "pve2_vm" {
    name = "k8-worker-01"
    description = "Open Tofu created VM"
    node_name = var.proxmox_node2
    vm_id = 200
    tags = ["tofu", "rocky", "vm", "k8_worker"]
    stop_on_destroy = true

    cpu {
        cores = 2
        type = "host"
    }

    memory {
        dedicated = 3072
    }

    disk {
        datastore_id = "local-lvm"
        import_from = var.vm_image_file_id
        interface = "virtio0"
        size = 10
    }

    network_device {
        bridge = "vmbr0"
        model = "virtio"
    }

    agent {
        enabled = true
    }

    operating_system {
        type = "l26"
    }

    initialization {
        ip_config {
            ipv4 {
                address = "192.168.1.20/24"
                gateway = "192.168.1.1"
            }
        }
        user_account {
            keys = [
                trimspace(tls_private_key.vm_key.public_key_openssh), 
                var.ssh_public_key,
                trimspace(tls_private_key.container_key.public_key_openssh)]
            password = random_password.vm_password.result
            username = "nufuk"
        }
    }
}

resource "proxmox_virtual_environment_vm" "pve3_vm" {
    name = "k8-worker-02"
    description = "Open Tofu created VM"
    node_name = var.proxmox_node3
    vm_id = 300
    tags = ["tofu", "rocky", "vm", "k8_worker"]
    stop_on_destroy = true

    cpu {
        cores = 2
        type = "host"
    }

    memory {
        dedicated = 3072
    }

    disk {
        datastore_id = "local-lvm"
        import_from = var.vm_image_file_id
        interface = "virtio0"
        size = 12
    }

    network_device {
        bridge = "vmbr0"
        model = "virtio"
    }

    agent {
        enabled = true
    }

    operating_system {
        type = "l26"
    }

    initialization {
        ip_config {
            ipv4 {
                address = "192.168.1.30/24"
                gateway = "192.168.1.1"
            }
        }
        user_account {
            keys = [
                trimspace(tls_private_key.vm_key.public_key_openssh), 
                var.ssh_public_key,
                trimspace(tls_private_key.container_key.public_key_openssh)]
            password = random_password.vm_password.result
            username = "nufuk"
        }
    }
}

resource "null_resource" "save_keys_1" {
    depends_on = [proxmox_virtual_environment_vm.pve1_vm, tls_private_key.vm_key]
    provisioner "remote-exec" {
        inline = [
            "mkdir -p /home/nufuk/.ssh",
            "echo '${tls_private_key.vm_key.private_key_openssh}' > /home/nufuk/.ssh/id_ed25519",
            "chmod 600 /home/nufuk/.ssh/id_ed25519",
            "echo '${tls_private_key.vm_key.public_key_openssh}' > /home/nufuk/.ssh/id_ed25519.pub",
            "chmod 644 /home/nufuk/.ssh/id_ed25519.pub"
        ]
    connection {
        type     = "ssh"
        user     = "nufuk"  # oder Ihr Benutzer
        private_key = tls_private_key.vm_key.private_key_openssh # oder Private Key
        host     = "192.168.1.10"
        port     = 22
    }
  }  
}

resource "null_resource" "save_keys_2" {
    depends_on = [proxmox_virtual_environment_vm.pve2_vm, tls_private_key.vm_key]
    provisioner "remote-exec" {
        inline = [
            "mkdir -p /home/nufuk/.ssh",
            "echo '${tls_private_key.vm_key.private_key_openssh}' > /home/nufuk/.ssh/id_ed25519",
            "chmod 600 /home/nufuk/.ssh/id_ed25519",
            "echo '${tls_private_key.vm_key.public_key_openssh}' > /home/nufuk/.ssh/id_ed25519.pub",
            "chmod 644 /home/nufuk/.ssh/id_ed25519.pub"
        ]
    connection {
        type     = "ssh"
        user     = "nufuk"  # oder Ihr Benutzer
        private_key = tls_private_key.vm_key.private_key_openssh # oder Private Key
        host     = "192.168.1.20"
        port     = 22
    }
  }  
}

resource "null_resource" "save_keys_3" {
    depends_on = [proxmox_virtual_environment_vm.pve3_vm, tls_private_key.vm_key]
    provisioner "remote-exec" {
        inline = [
            "mkdir -p /home/nufuk/.ssh",
            "echo '${tls_private_key.vm_key.private_key_openssh}' > /home/nufuk/.ssh/id_ed25519",
            "chmod 600 /home/nufuk/.ssh/id_ed25519",
            "echo '${tls_private_key.vm_key.public_key_openssh}' > /home/nufuk/.ssh/id_ed25519.pub",
            "chmod 644 /home/nufuk/.ssh/id_ed25519.pub"
        ]
    connection {
        type     = "ssh"
        user     = "nufuk"  # oder Ihr Benutzer
        private_key = tls_private_key.vm_key.private_key_openssh # oder Private Key
        host     = "192.168.1.30"
        port     = 22
    }
  }  
}

resource "random_password" "vm_password" {
  length           = 16
  override_special = "_-"
  special          = true
}

resource "tls_private_key" "vm_key" {
  algorithm = "ED25519"
}

output "vm_password" {
  value     = random_password.vm_password.result
  sensitive = true
}

output "vm_private_key" {
  value     = tls_private_key.vm_key.private_key_pem
  sensitive = true
}

output "vm_public_key" {
  value = tls_private_key.vm_key.public_key_openssh
}