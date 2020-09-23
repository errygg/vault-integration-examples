terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  # Use VAULT_TOKEN env var
}

locals {
  ui_ns = "ui"
  app_svr_ns = "app_server"
  db_ns = "database"
}

# # Create namespaces for 3-tier application

# resource "vault_namespace" "ui" {
#   #path = local.ui_ns
#   path  = "ui"
# }

# resource "vault_namespace" "app_server" {
#   path = local.app_svr_ns
# }

# resource "vault_namespace" "database" {
#   path = local.db_ns
# }

# UI namespace will use AppRole authentication
resource "vault_auth_backend" "ui_approle" {
  type = "approle"
  path = format("%s/%s", local.ui_ns, "approle")
}

# App Server namespace will use AppRole authentication
resource "vault_auth_backend" "app_svr_approle" {
  type = "approle"
  path = format("%s/%s", local.app_svr_ns, "approle")
}

# Database namespace will use Approle authentication
resource "vault_auth_backend" "db_approle" {
  type = "approle"
  path = format("%s/%s", local.db_ns, "approle")
}
