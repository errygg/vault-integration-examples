#!/bin/bash

echo ">>>> Getting vault pod..."
kubectl get pods -n vault

echo ">>>> Getting postgres pod..."
kubectl get pods -n postgres

echo ">>>> Getting app pod..."
kubectl get pods -n app
