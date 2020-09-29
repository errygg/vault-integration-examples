#!/usr/bin/env bash

export PATH=$PATH:/usr/local/bin
export DEFAULT_IP_ADDRESS="$(ip address show $(ls -1 /sys/class/net | grep -v lo | sort -r | head -n 1) | awk '{print $2}' | egrep -o '([0-9]+\.){3}[0-9]+')"

umask 022

echo "Installing dependencies ..."
apt-get update
apt-get install -y unzip jq

echo "Installing Consul ${consul_binary_filename} ..."
curl -v -s -O ${consul_binary_url}/${consul_binary_filename}

unzip ${consul_binary_filename}
mv consul /usr/local/bin

echo "Creating Consul service account ..."
useradd -r -d /etc/consul.d -s /bin/false consul

echo "Creating Consul directory structure ..."
mkdir /etc/consul{,.d}
chown consul:consul /etc/vault{,.d}
chmod 0750 /etc/consul{,.d}

mkdir /var/lib/consul
chown consul:consul /var/lib/consul
chmod 0750 /var/lib/consul

mkdir /data/consul
chown consul:consul /data/consul
chmod 0750 /data/consul

chown consul:consul /usr/local/bin/consul
chmod 0755 /usr/local/bin/consul

echo "Installing Vault ${binary_filename} ..."
curl -v -s -O ${binary_url}/${binary_filename}

unzip ${binary_filename}
mv vault /usr/local/bin

echo "Creating Vault service account ..."
useradd -r -d /etc/vault.d -s /bin/false vault

echo "Creating Vault directory structure ..."
mkdir /etc/vault{,.d}
chown vault:vault /etc/vault{,.d}
chmod 0750 /etc/vault{,.d}

mkdir /var/lib/vault
chown vault:vault /var/lib/vault
chmod 0750 /var/lib/vault

chown vault:vault /usr/local/bin/vault
chmod 0755 /usr/local/bin/vault

echo "Creating Vault config ..."

cat > /etc/vault.d/vault.hcl << EOF
ui = true
api_addr = "http://${vault_address}:443"
cluster_addr = "http://$DEFAULT_IP_ADDRESS:8201"

backend "consul" {
  address = "127.0.0.1:8500"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

listener "tcp" {
  address = "0.0.0.0:8770"
  tls_disable = 1
}
EOF

echo "Creating Consul client config ..."

cat > /etc/consul.d/consul.hcl << EOF
                  server=false
              datacenter="us-west-2"
                data_dir="/data/consul"
             client_addr="127.0.0.1"
          advertise_addr="$DEFAULT_IP_ADDRESS"
              retry_join=
EOF

chown root:vault /etc/vault.d/vault.hcl
chmod 0640 /etc/vault.d/vault.hcl

cat > /etc/systemd/system/vault.service << EOF
[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault.d/vault.hcl

[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
StartLimitIntervalSec=60
StartLimitBurst=3
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable vault
systemctl restart vault
