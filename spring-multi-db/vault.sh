#!/bin/sh

if [[ -d scratch ]]; then
  rm -Rf scratch
fi

mkdir scratch

cd scratch

VAULT_VERSION=1.4.3
VAULT_ZIP_FILE=vault_${VAULT_VERSION}_darwin_amd64.zip
wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/${VAULT_ZIP_FILE}

unzip $VAULT_ZIP_FILE
chmod 755 vault
./vault server -dev -dev-root-token-id=root
