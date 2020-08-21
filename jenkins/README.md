
1. Start the Jenkins server

```sh
$ brew service start jenkins

$ open http://localhost:8080

$ cat ~/.jenkins/initialAdminPassword
```

1. Select default plugins to install

1. Enter username (`admin`), password (`admin`), full name (`admin`), email address (`admin@admin.admin`)

1. Configure Jenkins Vault plugin
   Select `Manage Jenkins` -> `Manage Plugins` -> `Available`
   Search for "Vault"
   Select `Install` checkbox
   Select `Install without restart`

1. Start and configure Vault

```sh
$ cd vault
$ ./start-vault.sh
$ ./configure-vault.sh
$ cd ..
```

1. Get the approle for Jenkins

```sh
$ vault read auth/approle/role/jenkins/role-id

$ vault write -f auth/approle/role/jenkins/secret-id
```

1. Add the credential to Jenkins

1. Create a new pipeline job and copy the `Jenkinsfile` contents

1. Run the job and view the output

1. Remove the credential and recreate with "Vault Token File Credential"

1. Vault agent can now be used to manage this credential

Guidance from Cloudbees:

* storing the files containing secrets outside the workspace
* explicitly removing the files immediately they are no longer required, and not assuming that the operating system or build system will remove them
* storing the files containing secrets in a temporary file system
* performing an analysis of the build to ensure it is not (accidentally or maliciously) copying the secret to any other location
* storing all files containing secrets in a single directory tree
* giving the directory tree an obvious name (e.g. /secrets) to help those using the system understand what they are

My guidance:

For token management on Jenkins, the Jenkins Vault Plugin has a Vault Token File Credential that can be used in conjunction with Vault Agent Caching capability to keep the token fresh. The Jenkins Vault Plugin documentation calls out "You can use this in combination with a script that periodically refreshes your token." In this case the script would be Vault Agent."
