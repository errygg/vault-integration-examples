#!/bin/bash

echo ">>>> Running app..."
cd ./deployments/app
./run.sh

appid=$(kubectl get pods -n app --output=jsonpath={.items..metadata.name})

kubectl describe pod $appid -n app
