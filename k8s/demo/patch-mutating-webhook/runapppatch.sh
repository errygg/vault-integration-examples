#!/bin/bash

echo ">>>> Running app without patch..."
cd ../deployments/app_patch
./run.sh

appid=$(kubectl get pods -n app --output=jsonpath={.items..metadata.name})

kubectl describe pod $appid -n app
