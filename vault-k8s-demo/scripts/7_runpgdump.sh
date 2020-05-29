#!/bin/bash

echo ">>>> Run pg_dump job..."
cd ../deployments/pg_dump
./run.sh

echo -e ">>>> Waiting 10 seconds for pgdump job to complete..."
sleep 10

appid=$(kubectl get pods -n app --output=jsonpath={.items..metadata.name})

kubectl logs -n app $appid
