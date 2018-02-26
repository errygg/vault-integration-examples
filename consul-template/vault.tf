# resource "vault_auth_backend" "userpass" {
#   type = "userpass"
# }
#
# resource "vault_policy" "my-team" {
#   name = "my-team"
#
#   policy = <<EOT
# path "secret/my-app" {
#   policy = "write"
# }
# EOT
# }
# resource "vault_generic_secret" "my-user" {
#   path = "auth/userpass/users/myusername"
#
#   data_json = <<EOT
# {
#   "password": "mypassword"
# }
# EOT
# }

