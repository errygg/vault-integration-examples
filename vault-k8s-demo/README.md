# vault-k8s Sync Tool Dynamic Secrets Demo

## Versions

Consul Helm: 0.16.2
Vault Helm: 0.3.3
Helm: 3.0.3
Google Cloud SDK: 279.0.0

## Demo Steps

1. Run terraform to spin up the kubernetes cluster

```shell
$ cd terraform/
$ terraform apply
```

1. Configure `kubectl` to run locally

```shell
$ gcloud container clusters get-credentials <cluster-name> --region <region>
```

1. Setup the Kubernetes namespaces, install Helm TLS, add the bootstrap configs
and start up PostgreSQL and the Vault server and vault-k8s injector

```shell
$ cd scripts/
$ ./1_setup.sh
```

1. Show the pods that got created

```shell
$ ./2_getpods.sh
```

1. Run the app without the injector patch

```shell
$ ./3_runapppatch.sh
```

1. Run the check secrets script to observe the contents of the secrets file,
initially the file will not exist

```shell
$ ./4_checksecrets.sh
```

1. Run a watch on the app pods

```shell
$ watch kubectl get pods -n app -o jsonpath='{.items..spec.containers[*].name}'
```

1. Run the patch and watch the secrets and pods. You should observe the init
and sidecar containers starting up, and the init container going away. You
should also see the file contents of the secrets file display. Continue watching
to observe the reauth every 60 seconds with new secrets being rendered.

```shell
$ 5_patchapp.sh
```

1. Run postgress connection app

```shell
$ ./10_app.sh
```

1. Take a look at the fileserver brower to see secrets

```shell
$ kubectl port-forward $(kubectl get pods -n app -o jsonpath='{.items..metadata.name}') -n app 8080:8080
```

1. Take a look at the logs for the app to see the successful connection

```shell
$ kubectl logs -n app -c app $(kubectl get pods -n app -o jsonpath='{.items..metadata.name}')
```


Resources:

https://kubernetes.io/docs/tasks/run-application/update-api-object-kubectl-patch/


