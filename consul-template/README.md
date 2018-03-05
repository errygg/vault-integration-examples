# Consul Template Example for Vault/Chef Integration
This project provides an example on how to integrate Vault with Chef using a
Consul Template file.

## System Requirements
This project utilizes a local instance of Docker therefore you must have
Docker installed locally.

## Running Tests
In order to execute the test, you simply need to run `bundle exec kitchen test`.

### Under the hood
Here is what is going on when running the tests:

1. 3 containers are instantiated: consul, vault, client
2. Chef is installed and chef-solo is configured on the client
3. The client container runs berkshelf to vendor the cookbooks necessary to install consul-template
4. The client is then authenticated to vault and consul-template renders a file locally with credentials

TBD: Then we'll change the password in Vault and ensure that the client picks up this new change without doing anything!

NOTE: to reinitialize the vault, set CONSUL_HTTP_ADDR and run:
`consul kv delete -recurse vault`


In order to run this, it requires some manual intervention.

1. Run `bundle exec kitchen terraform` in the setup_stack module first.
2. cat out the tmp/vault_root_token.txt file and save that in a variable `export TF_VAR_user_token=<root_token>`.
3. Run `bundle exec kitchen terraform` in the config_stack module next.
4. Export the Vault address `export VAULT_ADDR=http://localhost:8200`
4. Get a user token with the new username/password created by the config_stack module
`vault login -method=userpass username=myusername` with `mypassword` as the password. Save off that token.
5. ssh into the client machine `ssh root@localhost -p 2222` with `root` as the password.
6. Export the token: `export VAULT_TOKEN=<user_token>` and run `consul-template -once -config=./consul_template_config.json`


Resources:
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
