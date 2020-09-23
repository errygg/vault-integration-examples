# Stop all the processes
pkill vault
sleep 5 # Wait for the sockets to close

# Remove the log files
rm -rf /tmp/vault-output.txt /tmp/vault.log /tmp/roleid /tmp/secretid /tmp/vault-agent-token /tmp/vault-agent.log

# Remove all the data dirs
rm -rf /tmp/vault
