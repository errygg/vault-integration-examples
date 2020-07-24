# Vault and K8s Demos

This project include a number of demos to show the capability of `vault-k8s` and
other integrations with Vault and Kubernetes.

## Versions Used

Consul Helm: 0.16.2
Vault Helm: 0.3.3
Helm: 3.0.3
Google Cloud SDK: 279.0.0
Terraform: 0.12.26

## Demo Steps

1. Setup your environment to use GCP

```shell
$ export GOOGLE_CLOUD_KEYFILE_JSON=<your-key-file>.json
```

1. Run terraform to spin up the kubernetes cluster in GCP

```shell
$ cd terraform/
$ terraform apply
```

1. Configure `kubectl` to run locally (this command is output from the terraform run)

```shell
$ gcloud container clusters get-credentials <cluster_name> --region <region>
```

1. See the appropriate `README.md` in the `demo` directory for the demo you'd
   like to run.

   These demos include:
   * Running Vault clients in a daemonset on each of the K8s nodes
   * Running an application that uses a mutating webhook to inject credentials at start
   * Patching an existing application to use a mutating webhook to inject credentials
   * Running a job that consumes credentials from Vault

## Resources

https://kubernetes.io/docs/tasks/run-application/update-api-object-kubectl-patch/
