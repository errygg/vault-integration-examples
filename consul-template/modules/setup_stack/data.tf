data "docker_registry_image" "consul_image" {
  name = "consul:latest"
}

data "docker_registry_image" "vault_image" {
  name = "vault:latest"
}

data "docker_registry_image" "client_image" {
  name = "rastasheep/ubuntu-sshd:latest"
}

data "template_file" "chef_node_file" {
  template = "${file("${path.module}/templates/node.json.tpl")}"

  vars {
    vault_addr  = "${docker_container.vault.ip_address}"
    consul_addr = "${docker_container.consul.ip_address}"
  }
}

data "template_file" "vault_config" {
  template = "${file("${path.module}/templates/vault.json.tpl")}"

  vars {
    consul_addr = "${docker_container.consul.ip_address}"
  }
}

data "template_file" "consul_config" {
  template = "${file("${path.module}/templates/consul.json.tpl")}"
}

data "template_file" "consul_template_config_file" {
  template = "${file("${path.module}/templates/consul-template.hcl.tpl")}"

  vars {
    vault_addr  = "${docker_container.vault.ip_address}"
    consul_addr = "${docker_container.consul.ip_address}"
  }
}
