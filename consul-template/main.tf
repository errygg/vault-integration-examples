resource "docker_image" "client" {
  name         = "${data.docker_registry_image.client_image.name}"
  keep_locally = true
}

resource "docker_image" "vault" {
  name         = "${data.docker_registry_image.vault_image.name}"
  keep_locally = true
}

resource "docker_image" "consul" {
  name         = "${data.docker_registry_image.consul_image.name}"
  keep_locally = true
}

resource "docker_container" "client" {
  image = "${docker_image.client.name}"
  name  = "client"

  ports {
    internal = 22
    external = 2222
  }

  provisioner "remote-exec" {
    connection {
      host     = "localhost"
      port     = "2222"
      type     = "ssh"
      user     = "root"
      password = "root"
    }

    inline = [
      "apt-get update",
      "apt-get install -y curl",
      "curl -L https://omnitruck.chef.io/install.sh | sudo bash",
    ]
  }

  #provisioner "chef" {}
}

resource "docker_container" "vault" {
  image = "${docker_image.vault.name}"
  name  = "vault"
}

resource "docker_container" "consul" {
  image = "${docker_image.consul.name}"
  name  = "consul"
}
