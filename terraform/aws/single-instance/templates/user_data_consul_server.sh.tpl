#!/usr/bin/env bash
export PATH=$PATH:/usr/local/bin
export DEFAULT_IP_ADDRESS="$(ip address show $(ls -1 /sys/class/net | grep -v lo | sort -r | head -n 1) | awk '{print $2}' | egrep -o '([0-9]+\.){3}[0-9]+')"

umask 022

echo "Installing dependencies ..."
apt-get update
apt-get install -y unzip jq

echo "Installing Consul ${consul_binary_filename} ..."
curl -s -O ${consul_binary_url}/${consul_binary_filename}

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

chown consul:consul /usr/local/bin/consul
chmod 0755 /usr/local/bin/consul

echo "Creating Consul config ..."

cat > /etc/consul.d/consul.hcl << EOF
ui = true
api_addr = "http://$DEFAULT_IP_ADDRESS:8200"
cluster_addr = "http://$DEFAULT_IP_ADDRESS:8201"
storage "file" {
  path = "/var/lib/vault"
}
listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = 1
}
listener "tcp" {
  address = "$DEFAULT_IP_ADDRESS:8200"
  tls_disable = 1
}
EOF
