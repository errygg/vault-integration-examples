# Jenkins Vault Plugin Demo

## Start the Jenkins server

```sh
$ brew service start jenkins

$ open http://localhost:8080

$ cat ~/.jenkins/initialAdminPassword
```

1. Select default plugins to install

1. Enter username (`admin`), password (`admin`), full name (`admin`), email address (`admin@admin.admin`)

## Configure Jenkins Vault plugin

1. Select `Manage Jenkins` -> `Manage Plugins` -> `Available`
1. Search for "Vault"
1. Select `Install` checkbox
1. Select `Install without restart`

## Configure the Jenkins job

1. Select `New Item` -> Enter the job name -> Select `Pipeline` -> Select `Ok`
1. Scroll down to "Pipeline" -> Select "Definition: Pipeline script" and change to "Pipeline script from SCM"
1. Select "SCM: None" and change to "Git" and enter Repository URL, the branch, and the file location for `Jenkinsfile`
1. Select "Save"

2. Start and configure Vault

```sh
$ cd vault
$ ./start-vault.sh
$ ./configure-vault.sh
$ cd ..
```

1. Get the approle for Jenkins

```sh
$ export VAULT_ADDR=http://127.0.0.1:8200

$ export VAULT_TOKEN=`cat /tmp/vault-output.txt |grep "Initial Root Token:" | sed -e "s/Initial Root Token: //g"`

$ vault read auth/approle/role/jenkins/role-id

$ vault write -f auth/approle/role/jenkins/secret-id
```

1. Add the credential to Jenkins

1. ID should be `vault-credential-id`

1. Run the job and view the output

## Vault Agent Example

1. Remove the credential and recreate with "Vault Token File Credential"

1. Run Vault agent

```sh

```

2. Vault agent can now be used to manage this credential








Guidance from Cloudbees:

* storing the files containing secrets outside the workspace
* explicitly removing the files immediately they are no longer required, and not assuming that the operating system or build system will remove them
* storing the files containing secrets in a temporary file system
* performing an analysis of the build to ensure it is not (accidentally or maliciously) copying the secret to any other location
* storing all files containing secrets in a single directory tree
* giving the directory tree an obvious name (e.g. /secrets) to help those using the system understand what they are

My guidance:

For token management on Jenkins, the Jenkins Vault Plugin has a Vault Token File Credential that can be used in conjunction with Vault Agent Caching capability to keep the token fresh. The Jenkins Vault Plugin documentation calls out "You can use this in combination with a script that periodically refreshes your token." In this case the script would be Vault Agent."


# Vault Agent