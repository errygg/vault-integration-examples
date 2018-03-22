# Consul Template Example for HashiCorp Vault and Chef Integration
This project provides an example on how to integrate HashiCorp Vault with Chef using a Consul Template file.

## System Requirements
This project utilizes a local instance of Docker therefore you must have
Docker installed locally.

## Execute Converge
Because of the nature of how Vault is instantiated, this project has to be executed in a particular order and with multiple steps.

1. Run `bundle exec kitchen converge` in the [setup_stack](consul-template/modules/setup_stack) module first.
2. Source the `./tmp/vault_root_token.txt` file which will export the `VAULT_TOKEN`
3. Export the Vault address `export VAULT_ADDR=http://localhost:8200`
4. Run `bundle exec kitchen converge` in the [config_stack](consul-template/modules/config_stack) module next.
5. Get a user token with the new username/password created by the config_stack module
`vault login -method=userpass username=myusername` with `mypassword` as the password. Save off that token.
6. ssh into the client machine `ssh root@localhost -p 2222` with `root` as the password.
7. Export the token: `export VAULT_TOKEN=<user_token>` and run `consul-template -once -config=./consul_template_config.json`

### Under the hood
Here is what is going on when running the tests:

1. 3 containers are instantiated: `consul`, `vault`, `client`
2. `chef` is installed and `chef-solo` is configured on the `client`
3. The `client` container runs `berkshelf` to vendor the cookbooks necessary to install `consul-template`
4. The `client` is then authenticated to `vault` and `consul-template` renders a file locally with credentials

*NOTE: to reinitialize the vault, set CONSUL_HTTP_ADDR and run:
`consul kv delete -recurse vault`*

## Resources

https://github.com/hashicorp/vault/issues/835

https://github.com/hashicorp/vault/issues/329

https://stackoverflow.com/questions/35885222/reading-vault-secrets-from-consul-template

https://github.com/hashicorp/consul-template

https://github.com/adamkrone/chef-consul-template

https://github.com/hashicorp/consul-template

https://www.consul.io/docs/agent/dns.html

https://werner-dijkerman.nl/2017/01/15/setting-up-a-secure-vault-with-a-consul-backend/

https://github.com/hashicorp/terraform/issues/8090

https://wilsonmar.github.io/hashicorp-vault/

https://github.com/hashicorp/vault/issues/72

http://chairnerd.seatgeek.com/practical-vault-usage/

https://www.vaultproject.io/docs/configuration/storage/consul.html

https://github.com/hashicorp/docker-consul/tree/master/0.X

https://medium.com/@pcarion/a-consul-a-vault-and-a-docker-walk-into-a-bar-d5a5bf897a87
