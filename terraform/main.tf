# 1. THE PROVIDER BLOCK (The Translator)
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# 2. THE RESOURCE BLOCK (The Infrastructure Builder)
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/hosts.ini"
  content  = <<EOT
[all]
node1 ansible_host=192.168.1.10
node2 ansible_host=192.168.1.11
node3 ansible_host=192.168.1.12
EOT
}
