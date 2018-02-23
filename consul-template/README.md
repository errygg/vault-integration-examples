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
