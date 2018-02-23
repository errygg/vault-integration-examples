data "docker_registry_image" "client_image" {
  name = "rastasheep/ubuntu-sshd:latest"
}

data "docker_registry_image" "vault_image" {
  name = "vault:latest"
}

data "docker_registry_image" "consul_image" {
  name = "consul:latest"
}
