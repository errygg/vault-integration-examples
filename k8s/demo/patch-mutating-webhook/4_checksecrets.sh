#!/bin/bash
while true
do
  appid=$(kubectl get pods -n app --output=jsonpath={.items..metadata.name})
  kubectl exec -it $appid -n app -c app -- cat /vault/secrets/db-creds
  sleep 5
done
