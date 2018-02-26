consul {
  address = "${consul_addr}:8500"
  vault {
    address = "http://${vault_addr}:8200"
  }
  template {
    source = "/root/secrets.txt.tpl"
    destination = "/root/secrets.txt"
  }
}
