resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "vault_policy" "myapp" {
  name = "myapp"

  policy = <<EOT
path "secret/*" {
  capabilities = ["create", "read"]
}
EOT
}

resource "vault_generic_secret" "myusername" {
  path = "auth/userpass/users/myusername"

  data_json = <<EOT
{
  "password": "mypassword",
  "policies": "${vault_policy.myapp.name}"
}
EOT
}

resource "vault_generic_secret" "mysecret" {
  path = "secret/mysecret"

  data_json = <<EOT
{
  "myvalue": "supersecret"
}
EOT
}
