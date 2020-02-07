#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

kubectl create -f ${DIR?}/service-account.yaml -n app

cat <<EOF | kubectl create -n app -f -
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: app
  labels:
    app: vault-agent-demo
spec:
  replicas: 1
  template:
    metadata:
      annotations:
      labels:
        app: vault-agent-demo
    spec:
      serviceAccountName: app
      containers:
      - name: app
        image: errygg/app:latest
        imagePullPolicy: Always
EOF
