# App-daemonset Demo

This demo will deploy the application with a Vault Agent Daemonset used to
broker connections to the actual vault server. This demonstrates how the
caching capability can be used to coordinate dynamic credentials with an init
and sidecar Vault agent container.

## Steps

1. Run `setup.sh`. This will cleanup your env then setup the k8 namespaces,
   create configs for the app and Vault to use, and deploy the database.

2. Run `getpods.sh` to check all the pods are running before going to the next
   step.

3. Run the `checksecrets.sh` script to watch the secrets. Note that there is a
   forced 15 second wait in the init container to watch the app container pick
   up the secret.

4. Run the `run.sh` script to run the app.
