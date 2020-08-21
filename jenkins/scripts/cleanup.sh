# Stop all the processes
pkill vault
#lsof -i TCP:8080 | awk '/LISTEN/ {print $2}' | xargs kill -9
sleep 5 # Wait for the sockets to close

# Remove the log files
rm -rf /tmp/vault-output.txt /tmp/vault.log

# Remove all the data dirs
rm -rf /tmp/vault
