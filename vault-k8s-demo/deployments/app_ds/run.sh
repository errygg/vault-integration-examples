#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

${DIR?}/cleanup.sh

kubectl create -f ${DIR?}/vault-agent.yaml --validate=true --namespace=vault
kubectl create -f ${DIR?}/service-account.yaml -n app
kubectl create -f ${DIR?}/configmap.yaml --namespace=app
kubectl create -f ${DIR?}/deployment.yaml -n app
