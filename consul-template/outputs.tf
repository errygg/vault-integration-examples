output "consul_container_name" {
  value = "${docker_container.consul.name}"
}

output "vault_container_name" {
  value = "${docker_container.vault.name}"
}

output "client_container_name" {
  value = "${docker_container.client.name}"
}
