data "docker_registry_image" "vault_image" {
  name = "vault:latest"
}

data "docker_registry_image" "client_image" {
  name = "rastasheep/ubuntu-sshd:latest"
}
