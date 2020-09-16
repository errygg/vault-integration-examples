#!/bin/sh

OUTPUT=/tmp/vault-output.txt
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true

vault operator init -n 1 -t 1 > ${OUTPUT?}

unseal=$(cat ${OUTPUT?} | grep "Unseal Key 1:" | sed -e "s/Unseal Key 1: //g")
root=$(cat ${OUTPUT?} | grep "Initial Root Token:" | sed -e "s/Initial Root Token: //g")

vault operator unseal ${unseal?}

vault login -no-print ${root?}

vault policy write jenkins jenkins-policy.hcl
vault auth enable approle
vault write auth/approle/role/jenkins secret_id_ttl=5m token_ttl=5m token_max_ttl=10m policies="jenkins"

vault secrets enable -version=1 -path=kv_v1 kv

vault kv put kv_v1/test value=ur$3cr3t!!
