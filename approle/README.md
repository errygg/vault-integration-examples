# AppRole Example for Vault/Terraform Integration
This project expands on the concepts presented in HashiCorp's
[Vault/Chef/Terraform Webinar](https://www.youtube.com/watch?v=OIcIzFWjThM).
Instead of using Chef as the mechanism to deliver the Secret ID For the Vault
AppRole authentication backend, we'll use Terraform to deliver both the
Secret ID and the Role ID. The Secret ID will be delivered via a Docker env
variable and we'll keep the Role ID delivery mechanism the same via Terraform.
Since Docker does not provide user data like AWS, we'll use scripts to deliver
the information we need.

## System Requirements
This project utilizes a local instance of Docker therefore you must have
Docker installed locally.

## Running Tests

### Under the hood

### Manual interactions

## Resources
https://github.com/hashicorp/vault-guides/tree/master/identity/vault-chef-approle
https://www.vaultproject.io/docs/auth/approle.html
https://www.vaultproject.io/api/auth/approle/index.html
