# Allow creating tokens
path "auth/token/create" {
  capabilities = ["update"]
}

# Allow reading k/v version 1 secrets
path "kv_v1/*" {
  capabilities = ["read"]
}

# Allow reading k/v version 2 secrets
path "kv_v2/*" {
  capabilities = ["read"]
}
