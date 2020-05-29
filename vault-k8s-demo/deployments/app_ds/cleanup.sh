#!/bin/bash

kubectl delete daemonset,configmap --selector=app=vault-agent --namespace=vault
kubectl delete deployment app -n app
kubectl delete serviceaccount app -n app
kubectl delete configmap vault-agent-config -n app
