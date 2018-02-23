# Consul Template Example for Vault/Chef Integration
This project provides an example on how to integrate Vault with Chef using a
Consul Template file. In order to run this locally, we are using
kitchen-terraform to instantiate Docker containers. Firstly, we'll instantiate
a container that will include a running Vault and Consul instance in dev mode.
Then we'll instantiate a client that will be used to run the Chef code to
install and configure consul-template, authenticate against the Vault/Consul
instance and render a file local on the client. Then we'll change the password
in Vault and ensure that the client picks up this new change without doing
anything!

NOTE: The current terraform-docker provider does not kill running instances. You will need to stop and prune your containers manually. You can run the following command to stop and delete all running containers:
`docker ps -q |xargs docker rm && docker container prune -f`

Also, to clean up your images run: `docker rmi $(docker images --filter "dangling=true" -q --no-trunc)`
