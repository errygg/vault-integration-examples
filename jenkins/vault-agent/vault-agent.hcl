pid_file = "/tmp/vault-agent.pid"

auto_auth {
  method "approle" {

  }
  sink "file" {
    config = {
      path = "/tmp/vault-agent-token"
    }
  }
}

vault {
  address = "http://localhost:8200"
}

template {

}
