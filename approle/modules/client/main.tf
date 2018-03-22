resource "docker_image" "client" {
  name         = "${data.docker_registry_image.client_image.name}"
  keep_locally = true
}

resource "docker_container" "client" {
  image    = "${docker_image.client.name}"
  name     = "client.server"
  networks = ["${docker_network.private_network.id}"]

  env = [
    "VAULT_ADDR=http://${var.vault_ip_address}:8200",
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

  # Init and unseal the Vault
  # TODO - this requires that Vault version ~> 0.9.4 is installed locally
  provisioner "local-exec" {
    command = <<EOT
mkdir -p ${path.module}/tmp &&\
export VAULT_ADDR=http://localhost:8200 &&\
VAULT_INIT_DATA=`vault operator init -format=json -key-shares=1 -key-threshold=1` &&\
VAULT_ROOT_TOKEN=`echo $VAULT_INIT_DATA | jq -r '.root_token'` &&\
echo $VAULT_ROOT_TOKEN > ${path.module}/tmp/vault_root_token.txt &&\
VAULT_UNSEAL_KEY=`echo $VAULT_INIT_DATA | jq -r '.unseal_keys_b64 | .[]'` &&\
echo $VAULT_UNSEAL_KEY > ${path.module}/tmp/vault_unseal_key.txt &&\
vault operator unseal $VAULT_UNSEAL_KEY
EOT
  }
}
