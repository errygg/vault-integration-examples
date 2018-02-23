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

resource "docker_network" "private_network" {
  name = "test_network"
}

resource "docker_container" "client" {
  image    = "${docker_image.client.name}"
  name     = "client"
  networks = ["${docker_network.private_network.id}"]

  ports {
    internal = 22
    external = 2222
  }

  provisioner "file" {
    connection {
      host     = "localhost"
      port     = "2222"
      user     = "root"
      password = "root"
    }

    source      = "files/"
    destination = "/root"
  }

  provisioner "file" {
    connection {
      host     = "localhost"
      port     = "2222"
      user     = "root"
      password = "root"
    }

    source      = "${data.template_file.chef_node_file.rendered}"
    destination = "/root"
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
      "apt-get install -y curl build-essential",
      "mkdir -p /root/chef/cookbooks",
      "curl -L https://omnitruck.chef.io/install.sh | sudo bash",
      "/opt/chef/embedded/bin/gem install berkshelf --no-ri --no-rdoc",
      "ln -s /opt/chef/embedded/bin/berks /usr/local/bin/berks",
      "berks vendor /root/chef/cookbooks/ -b ./Berksfile",
      "chef-solo -c /root/solo.rb",
    ]
  }
}

resource "docker_container" "vault" {
  image    = "${docker_image.vault.name}"
  name     = "vault"
  networks = ["${docker_network.private_network.id}"]
}

resource "docker_container" "consul" {
  image    = "${docker_image.consul.name}"
  name     = "consul"
  networks = ["${docker_network.private_network.id}"]
}
