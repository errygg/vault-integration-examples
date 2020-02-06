#!/bin/bash

echo ">>>> Run pg_dump job..."
cd ../deployments/pg_dump
./run.sh

echo -e ">>>> Waiting 5 seconds for pgdump job to complete..."
sleep 5

appid=$(kubectl get pods -n app --output=jsonpath={.items..metadata.name})

kubectl logs -n app $appid
