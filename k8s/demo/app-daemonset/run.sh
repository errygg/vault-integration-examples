#!/bin/bash

echo ">>>> Running app-daemonset demo..."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

kubectl create -f ${DIR?}/deployments/vault-agent.yaml --validate=true --namespace=vault
kubectl create -f ${DIR?}/deployments/service-account.yaml -n app
kubectl create -f ${DIR?}/deployments/configmap.yaml --namespace=app
kubectl create -f ${DIR?}/deployments/deployment.yaml -n app

appid=$(kubectl get pods -n app --output=jsonpath={.items..metadata.name})

kubectl describe pod $appid -n app
