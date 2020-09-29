variable "config_destination_dir" {
  description = "Destination directory for the Vault server configuration file"
  default     = "/home/ubuntu"
}

variable "vault_binary_filename" {
  description = "Zip file name of the vault binary"
  default     = "vault_1.2.3%2Bent_linux_amd64.zip"
}

variable "vault_binary_url" {
  description = "Location of `vault_binary_filename`"
  default     = "https://releases.hashicorp.com/vault/1.2.3%2Bent"
}

variable "vault_api_ingress_cidr_blocks" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "ssh_public_key" {
  type        = "string"
  description = "SSH public key for Vault instances"
  default     = "~/.ssh/id_rsa.pub"
}

variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the Vault cluster used for the license entitlement"
  default     = "erikryggtestcluster"
}
