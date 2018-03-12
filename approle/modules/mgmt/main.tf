resource "docker_network" "private_network" {
  name = "test-network"
}

resource "docker_image" "vault" {
  name         = "${docker.data_registry_image.vault_image.name}"
  keep_locally = true
}

resource "docker_container" "vault" {
  image    = "${docker_image.vault.name}"
  name     = "vault.server"
  networks = ["${docker_network.private_network.id}"]
  command  = ["server", "-dev"]
  env      = ["VAULT_LOCAL_CONFIG=${data.template_file.vault_config.rendered}"]

  capabilities {
    add = ["IPC_LOCK"]
  }

  ports {
    internal = 8200
    external = 8200
  }
}
