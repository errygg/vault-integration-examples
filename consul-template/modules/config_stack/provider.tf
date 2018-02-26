provider "vault" {
  address = "http://localhost:8200"
  token   = "${var.user_token}"
}
