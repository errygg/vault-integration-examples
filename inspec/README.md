# inspec

This directory provides guidance and direction on how to use InSpec to test
deployed HashiCorp Vault resources. This can be done in 2 ways as described:

1. kitchen terraform testing
2. InSpec compliance testing

## Demo

1. Start and unseal a Vault server

  ```bash
  ./scripts/start-vault.sh
  ```

  ```bash
  ./scripts/configure-vault.sh
  ```

1. Set the token to run `terraform`

  ```bash
  export VAULT_TOKEN=$(cat /tmp/vault-output.txt | grep "Initial Root Token:" | sed -e "s/Initial Root Token: //g")
  ```

1. Run `terraform` to configure Vault

  ```bash
  cd ./terraform; terraform plan; terraform apply; cd ..
  ```

## InSpec Compliance Testing

> Note that the `inspec-vault` plugin currently only provides the capability to test KV secrets

Install the `inspec-vault` plugin:

```bash
inspec plugin install inspec-vault
```

1. Run `inspec` tests

  ```bash
  inspec exec ./vault/profile
  ```
