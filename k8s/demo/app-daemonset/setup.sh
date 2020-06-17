#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NAMESPACE='vault'
export CA_BUNDLE=$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}')

echo ">>>> Cleanup any old objects..."
${DIR?}/../cleanup.sh

echo -e "\n>>>> Create Kubernetes namespaces..."
kubectl create namespace vault
kubectl create namespace postgres
kubectl create namespace app

helm delete tls-test
helm install tls-test --namespace=${NAMESPACE?} ${DIR?}/../../deployments/tls

kubectl get secret tls-test-client --namespace=${NAMESPACE?} --export -o yaml |\
  kubectl apply --namespace=app -f -

echo -e "\n>>>> Add bootstrap and configs for Vault server..."
kubectl create secret generic demo-vault \
    --from-file ${DIR?}/../../configs/policy/app-policy.hcl \
    --from-file ${DIR?}/../../configs/policy/pgdump-policy.hcl \
    --from-file ${DIR?}/../../configs/bootstrap.sh \
    --namespace=${NAMESPACE?}

kubectl label secret demo-vault app=vault-agent-demo \
    --namespace=${NAMESPACE?}

echo -e "\n>>>> Install, configure, and start PostgreSQL in Kubernetes..."
${DIR?}/../../deployments/postgres/run.sh

echo -e "\n>>>> Install, configure, and start Vault server..."
helm install vault \
  --namespace="${NAMESPACE?}" \
  -f ${DIR?}/../../deployments/vault/values.yaml ${DIR?}/../../deployments/vault-helm
