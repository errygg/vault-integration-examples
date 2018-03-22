resource "docker_network" "private_network" {
  name = "test-network"
}

resource "docker_image" "consul" {
  name         = "${data.docker_registry_image.consul_image.name}"
  keep_locally = true
}

resource "docker_image" "vault" {
  name         = "${data.docker_registry_image.vault_image.name}"
  keep_locally = true
}

resource "docker_image" "client" {
  name         = "${data.docker_registry_image.client_image.name}"
  keep_locally = true
}

resource "docker_container" "consul" {
  image    = "${docker_image.consul.name}"
  name     = "consul.server"
  networks = ["${docker_network.private_network.id}"]
  env      = ["CONSUL_LOCAL_CONFIG=${data.template_file.consul_config.rendered}"]
}

resource "docker_container" "vault" {
  image    = "${docker_image.vault.name}"
  name     = "vault.server"
  networks = ["${docker_network.private_network.id}"]
  command  = ["server"]
  env      = ["VAULT_LOCAL_CONFIG=${data.template_file.vault_config.rendered}"]

  capabilities {
    add = ["IPC_LOCK"]
  }

  ports {
    internal = 8200
    external = 8200
  }
}

resource "docker_container" "client" {
  image    = "${docker_image.client.name}"
  name     = "client.server"
  networks = ["${docker_network.private_network.id}"]

  env = [
    "VAULT_ADDR=http://${docker_container.vault.ip_address}:8200",
    "CONSUL_HTTP_ADDR=${docker_container.consul.ip_address}:8500",
  ]

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

    source      = "files/chef/"
    destination = "/root"
  }

  provisioner "file" {
    connection {
      host     = "localhost"
      port     = "2222"
      user     = "root"
      password = "root"
    }

    content     = "${data.template_file.chef_node_file.rendered}"
    destination = "/root/node.json"
  }

  # TODO - this can also be done with chef using the consul_template_config
  # custom resource in the consul-template cookbook
  provisioner "file" {
    connection {
      host     = "localhost"
      port     = "2222"
      user     = "root"
      password = "root"
    }

    content     = "${data.template_file.consul_template_config_file.rendered}"
    destination = "/root/consul_template_config.json"
  }

  # TODO - this can also be pushed via chef in a wrapper cookbook
  provisioner "file" {
    connection {
      host     = "localhost"
      port     = "2222"
      user     = "root"
      password = "root"
    }

    source      = "files/consul-template/secrets.txt.tpl"
    destination = "/root/secrets.txt.tpl"
  }

  # Install dependencies
  # Berkshelf version in ChefDK isn't working, so manually doing it here
  provisioner "remote-exec" {
    connection {
      host     = "localhost"
      port     = "2222"
      type     = "ssh"
      user     = "root"
      password = "root"
    }

    inline = [
      "apt-get -y update",
      "apt-get -y install curl build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev unzip jq",
      "wget -O /tmp/ruby.tar.gz http://ftp.ruby-lang.org/pub/ruby/2.5/ruby-2.5.0.tar.gz",
      "cd /tmp",
      "tar -xvzf ruby.tar.gz",
      "cd /tmp/ruby-2.5.0/",
      "./configure --prefix=/usr/local",
      "make",
      "make install",
      "gem install berkshelf --no-ri --no-rdoc",
      "ln -s /opt/chef/embedded/bin/berks /usr/local/bin/berks",
      "curl -L https://omnitruck.chef.io/install.sh | bash",
      "mkdir -p /cookbooks",
      "berks vendor /cookbooks -b /root/Berksfile",
      "chef-client --local-mode -j /root/node.json",
    ]
  }

  # Consul cookbook isn't working, so manually doing it here
  provisioner "remote-exec" {
    connection {
      host     = "localhost"
      port     = "2222"
      type     = "ssh"
      user     = "root"
      password = "root"
    }

    inline = [
      "wget -O /tmp/consul.zip https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip",
      "unzip -d /usr/local/bin /tmp/consul.zip",
      "chmod 755 /usr/local/bin/consul",
    ]
  }

  # Init and unseal the Vault
  # TODO - this requires that Vault version ~> 0.9.4 is installed locally
  provisioner "local-exec" {
    command = <<EOT
mkdir -p ${path.module}/tmp &&\
export VAULT_ADDR=http://localhost:8200 &&\
VAULT_INIT_DATA=`vault operator init -format=json -key-shares=1 -key-threshold=1` &&\
VAULT_ROOT_TOKEN=`echo $VAULT_INIT_DATA | jq -r '.root_token'` &&\
echo VAULT_TOKEN=$VAULT_ROOT_TOKEN > ${path.module}/tmp/vault_root_token.txt &&\
VAULT_UNSEAL_KEY=`echo $VAULT_INIT_DATA | jq -r '.unseal_keys_b64 | .[]'` &&\
echo $VAULT_UNSEAL_KEY > ${path.module}/tmp/vault_unseal_key.txt &&\
vault operator unseal $VAULT_UNSEAL_KEY
EOT
  }
}
