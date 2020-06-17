#!/bin/bash

echo ">>>> Getting vault pod..."
kubectl get pods -n vault

echo -e "\n>>>> Getting postgres pod..."
kubectl get pods -n postgres

echo -e "\n>>>> Getting app pod..."
kubectl get pods -n app
