{
  "consul-template": {
    "consul_addr": "${consul_addr}:8500",
    "vault_addr": "${vault_addr}:8200",
    "init_style": "upstart"
  },
  "vault": {
    "mode": "client"
  },
  "run_list": [
    "recipe[vault]",
    "recipe[consul-template::install_binary]"
  ]
}
