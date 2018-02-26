output "consul_container_name" {
  value = "${docker_container.consul.name}"
}

output "consul_ip_address" {
  value = "${docker_container.consul.ip_address}"
}

output "vault_container_name" {
  value = "${docker_container.vault.name}"
}

output "vault_ip_address" {
  value = "${docker_container.vault.ip_address}"
}

output "client_container_name" {
  value = "${docker_container.client.name}"
}
