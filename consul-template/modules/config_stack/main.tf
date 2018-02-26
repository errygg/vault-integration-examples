resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "vault_policy" "my-app" {
  name = "my-app"

  policy = <<EOT
path "secret/*" {
  capabilities = ["create", "read"]
}
EOT
}

resource "vault_generic_secret" "my-user" {
  path = "auth/userpass/users/myusername"

  data_json = <<EOT
{
  "password": "mypassword",
  "policies": "${vault_policy.my-app.name}"
}
EOT
}

resource "vault_generic_secret" "my-secret" {
  path = "secret/my-secret"

  data_json = <<EOT
{
  "my-value": "supersecret"
}
EOT
}
