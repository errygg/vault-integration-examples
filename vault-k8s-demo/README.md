# Vault Kubernetes Demos

## Versions

Minikube: 0.28.0
Consul Helm: 0.16.2
Consul:
Vault Helm:
Vault: 
PostgreSQL: 10.4
Helm: 3.0.3
Google Cloud SDK: 279.0.0

## vault-k8s Sync Tool Dynamic Secrets

1. Run terraform to spin up the kubernetes cluster

```shell
$ cd terraform/
$ terraform apply
```

1. Configure `kubectl`

```shell
$ gcloud container clusters get-credentials <cluster-name> --region <region>
```

1. Run the steps in `vault-agent-demo`

Resources:

https://kubernetes.io/docs/tasks/run-application/update-api-object-kubectl-patch/


