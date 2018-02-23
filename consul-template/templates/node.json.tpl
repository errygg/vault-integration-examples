{
  "consul-template": {
    "consul_addr": "${consul_addr}:8500",
    "vault_addr": "${vault_addr}:8200",
    "init_style": "upstart"
  },
  "run_list": [
    "recipe[consul-template::default]"
  ]
}
