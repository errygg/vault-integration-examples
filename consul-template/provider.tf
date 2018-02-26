provider "docker" {
  host = "unix://localhost/var/run/docker.sock"
}

provider "template" {}

# provider "vault" {
#   address = "http://localhost:8200"
#   token = "${data.}"
# }

