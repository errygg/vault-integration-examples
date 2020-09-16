pid_file = "/tmp/vault-agent.pid"

auto_auth {
  method "approle" {
    config = {
      role_id_file_path = "/tmp/roleid"
      secret_id_file_path = "/tmp/secretid"
      remove_secret_id_file_after_reading = false
    }
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
