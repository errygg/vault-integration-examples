# Spring Cloud Vault Example

This project includes a demo on how to configure Spring Cloud Vault to authenticate with Vault and consume credentials using a standard HTTP response as well as using Spring's annotations.

## Demo Steps

1. Start and configure Vault

```sh
cd ./scripts
./start-vault.sh
./configure-vault.sh
cd ../
```

2. Get the root token from the output file

```sh
cat /tmp/vault-output.txt | grep "Root Token"
```

Copy the root token to the `spring.cloud.vault.token` file in `./src/main/resources/bootstrap.properties` file.

3. Run the build

```sh
./gradlew bootRun
```

You should see the following log output:

```text
2020-09-16 16:30:37.305  INFO 6652 --- [           main] vaultpcf.VaultPcfApplication             : 'username' injected via @Value : user
2020-09-16 16:30:37.306  INFO 6652 --- [           main] vaultpcf.VaultPcfApplication             : 'password' injected via @Value : pass
2020-09-16 16:30:37.316  INFO 6652 --- [           main] vaultpcf.VaultPcfApplication             : 'username' from response: user
2020-09-16 16:30:37.316  INFO 6652 --- [           main] vaultpcf.VaultPcfApplication             : 'username' from response: pass
```

And you can go to http://localhost:8080 and see:

```text
Read /kv/vaultpcf username: user and password: pass
```

4. Cleanup the Vault deployment by running `./scripts/cleanup.sh`
