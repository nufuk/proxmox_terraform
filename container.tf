resource "proxmox_virtual_environment_container" "ansible_container" {
    node_name = var.proxmox_node3
    vm_id = 301
    description = "Ansible Container created by openTofu"
    unprivileged = true
    start_on_boot = true
    tags = ["tofu", "ansible", "ct", "lxc", "container"]
    
    features {
        nesting = true
    }

    operating_system {
        template_file_id = var.container_template_file_id
        type = "debian"
    }

    cpu {
        cores = 1
    }

    memory {
        dedicated = 512
    }

    network_interface {
        name = "eth0"
        bridge = "vmbr0"
    }

    disk {
        datastore_id = "local-lvm"
        size = 2
    }

    initialization {
        hostname = "lxc-ansible"
        ip_config {
            ipv4 {
                address = "192.168.1.31/24"
                gateway = "192.168.1.1"
            }
        }
        user_account {
            keys = [
                trimspace(tls_private_key.container_key.public_key_openssh), 
                var.ssh_public_key, 
                trimspace(tls_private_key.vm_key.public_key_openssh)]
            password = random_password.container_password.result
        }
    }
}

resource "null_resource" "configure_locale" {
    depends_on = [proxmox_virtual_environment_container.ansible_container, null_resource.save_keys_ansible]
    provisioner "remote-exec" {
        inline = [
            # create inithooks.conf to skip GUI setup
            "touch /etc/inithooks.conf",
            "echo 'ROOT_PASS=\"${random_password.container_password.result}\"' > /etc/inithooks.conf",
            "echo 'APP_PASS=\"${random_password.app_password.result}\"' >> /etc/inithooks.conf",
            "echo 'APP_EMAIL=\"info@nufuk.de\"' >> /etc/inithooks.conf",
            "echo 'APP_DOMAIN=DEFAULT' >> /etc/inithooks.conf",
            "echo 'SEC_ALERTS=SKIP' >> /etc/inithooks.conf",
            "echo 'SEC_UPDATES=FORCE' >> /etc/inithooks.conf", 
            "echo 'HUB_APIKEY=SKIP' >> /etc/inithooks.conf",
            #Set locale for ansible
            "echo 'LC_ALL=de_DE.UTF-8' >> /etc/environment",
            "echo 'de_DE.UTF-8 UTF-8' >> /etc/locale.gen",
            "echo 'LANG=de_DE.UTF-8' > /etc/locale.conf",
            "apt-get clean && apt-get update -y",
            "apt-get install locales -y",
            "locale-gen de_DE.UTF-8",
            "update-locale LANG=de_DE.UTF-8 LC_CTYPE=de_DE.UTF-8",
            "echo 'export LC_ALL=de_DE.UTF-8' >> /root/.bashrc",
            "echo 'export LANG=de_DE.UTF-8' >> /root/.bashrc",
            "echo 'export LANGUAGE=de_DE.UTF-8' >> /root/.bashrc",
        ]
    connection {
        type     = "ssh"
        user     = "root"  # oder Ihr Benutzer
        private_key = tls_private_key.container_key.private_key_openssh # oder Private Key
        host     = "192.168.1.31"
        port     = 22
    }
  }  
}

resource "null_resource" "save_keys_ansible" {
    depends_on = [proxmox_virtual_environment_container.ansible_container, tls_private_key.container_key]
    provisioner "remote-exec" {
        inline = [
            "mkdir -p /root/.ssh",
            "echo '${tls_private_key.container_key.private_key_openssh}' > /root/.ssh/id_ed25519",
            "chmod 600 /root/.ssh/id_ed25519",
            "echo '${tls_private_key.container_key.public_key_openssh}' > /root/.ssh/id_ed25519.pub",
            "chmod 644 /root/.ssh/id_ed25519.pub"
        ]
    connection {
        type     = "ssh"
        user     = "root"  # oder Ihr Benutzer
        private_key = tls_private_key.container_key.private_key_openssh # oder Private Key
        host     = "192.168.1.31"
        port     = 22
    }
  }  
}

resource "random_password" "container_password" {
  length = 16
  override_special = "_-!?"
  min_lower = 1
  min_numeric = 1
  min_special = 1
  min_upper = 1
  special = true
}

resource "random_password" "app_password" {
  length           = 16
  override_special = "_-"
  special          = true
}

resource "tls_private_key" "container_key" {
  algorithm = "ED25519"
}

output "container_private_key" {
  value     = tls_private_key.container_key.private_key_pem
  sensitive = true
}

output "container_public_key" {
  value = tls_private_key.container_key.public_key_openssh
}

output "container_generated_password" {
  value = random_password.container_password.result
  sensitive = true
}