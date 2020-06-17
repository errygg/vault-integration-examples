#!/bin/bash
while true
do
  appid=$(kubectl get pods -n app --output=jsonpath={.items..metadata.name})
  echo ">>>>Vault agent init container..."
  kubectl exec -it $appid -n app -c vault-agent-init -- cat /vault/secrets/db-creds
  echo ">>>>Vault agent container..."
  kubectl exec -it $appid -n app -c vault-agent -- cat /vault/secrets/db-creds
  echo ">>>>App container..."
  kubectl exec -it $appid -n app -c app -- cat /vault/secrets/db-creds
  echo ""
  sleep 5
done
