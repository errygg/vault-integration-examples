{
  "consul-template": {
    "consul_addr": "${consul_addr}:8500",
    "vault_addr": "http://${vault_addr}:8200",
    "init_style": "upstart"
  },
  "vault": {
    "download_url": "https://releases.hashicorp.com/vault/0.9.4/vault_0.9.4_linux_amd64.zip"
  },
  "run_list": [
    "recipe[vault]",
    "recipe[consul-template::install_binary]"
  ]
}
