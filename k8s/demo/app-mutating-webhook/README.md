# App-mutating-webhook Demo

This demo will configure the `vault-k8s` injector service and register with K8s
as a Mutating Admission Webhook. The application is annotated to use this service
to present secrets to the init, app, and sidecar containers. See the
[HashiCorp Blog](https://www.hashicorp.com/blog/injecting-vault-secrets-into-kubernetes-pods-via-a-sidecar/)
for more information on this process.

## Steps

1. Run `setup.sh`. This will cleanup your env then setup the k8 namespaces,
   create configs for the app and Vault to use, and deploy the database.

2. Run `getpods.sh` to check all the pods are running before going to the next
   step.

3. Run the `checksecrets.sh` script to watch the secrets. Note that there is a
   forced 15 second wait in the init container to watch the app container pick
   up the secret.

4. Run the `run.sh` script to run the app.
