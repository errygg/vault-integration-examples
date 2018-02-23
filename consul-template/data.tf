data "docker_registry_image" "client_image" {
  name = "rastasheep/ubuntu-sshd:latest"
}

data "docker_registry_image" "vault_image" {
  name = "vault:latest"
}

data "docker_registry_image" "consul_image" {
  name = "consul:latest"
}

data "template_file" "chef_node_file" {
  template = "${file("${path.module}/templates/node.json.tpl")}"

  vars {
    vault_addr  = "${docker_container.vault.ip_address}"
    consul_addr = "${docker_container.consul.ip_address}"
  }
}
