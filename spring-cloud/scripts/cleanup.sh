# Stop all the processes
pkill vault

# Remove the log files
rm -rf /tmp/vault-output.txt /tmp/vault.log

# Remove all the data dirs
rm -rf /tmp/vault
