variable "location" {
  description = "Location (Region) of Azure"
  default     = "westus"
}

variable "ssh_key_file" {
  description = "SSH key file"
  default     = "~/.ssh/id_rsa.pub"
}

variable "config_destination_dir" {
  description = "Destination directory for the Vault server configuration file"
  default     = "/home/ubuntu"
}

variable "vault_binary_filename" {
  description = "Zip file name of the vault binary"
  default     = "vault_1.1.4_linux_amd64.zip"
}

variable "vault_binary_url" {
  description = "Location of `vault_binary_filename`"
  default     = "https://releases.hashicorp.com/vault/1.1.4/"
}
