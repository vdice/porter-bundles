This is an example bundle which deploys an Azure Keyvault instance.

It's currently configured with sample credential and parameter sets using secrets.  These secrets utilize Porter's Azure secrets plugin (via the sample porter config included) to resolve the values.

Prereqs to run:
 - Requires an Azure account
 - Create the keyvault listed in the sample Porter config (currently `my-keyvault`)
 - Create secrets for all of the referenced credentials and parameters in this keyvault (e.g. `porter-keyvault-resource-group`, `porter-keyvault-client-id`, etc.)
 - Execute this bundle with the credential and parameter sets supplied, e.g. 
 `porter install -p ./sample-paramset-secrets.json -c ./sample-credset-secrets.json`