terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.25.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "ubuntu" {
  name         = "pycontribs/ubuntu:latest"
  keep_locally = true
}

resource "docker_container" "fin_nodes" {
  count = 3
  name  = "fin-node-${count.index + 1}"
  image = docker_image.ubuntu.image_id
  
  ports {
    internal = 22
    external = 2221 + count.index
  }
  ports {
    internal = 80
    external = 8081 + count.index
  }
}

# Automatically creates your hosts.ini file with no manual typing needed
resource "local_file" "ansible_inventory" {
  filename = "../ansible/hosts.ini"
  content  = <<EOT
[financial_servers]
node1 ansible_host=127.0.0.1 ansible_port=2221
node2 ansible_host=127.0.0.1 ansible_port=2222
node3 ansible_host=127.0.0.1 ansible_port=2223

[financial_servers:vars]
ansible_user=root
ansible_password="{{ vault_secret_password }}"
EOT
}
