resource "docker_image" "client" {
  name = "${data.docker_registry_image.client_image.name}"
}

resource "docker_image" "vault" {
  name = "${data.docker_registry_image.vault_image.name}"
}

resource "docker_image" "consul" {
  name = "${data.docker_registry_image.consul_image.name}"
}

resource "docker_container" "client" {
  image                 = "${docker_image.client.name}"
  name                  = "client"
  destroy_grace_seconds = 2
}

resource "docker_container" "vault" {
  image                 = "${docker_image.vault.name}"
  name                  = "vault"
  destroy_grace_seconds = 2
}

resource "docker_container" "consul" {
  image                 = "${docker_image.consul.name}"
  name                  = "consul"
  destroy_grace_seconds = 2
}
