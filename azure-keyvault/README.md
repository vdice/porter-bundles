This is an example bundle which deploys an [Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/) instance via Porter's [Terraform](https://github.com/deislabs/porter-terraform) mixin.

It's currently configured with sample credential and parameter sets using a mix of secrets and other sources.  The items of type `secret` utilize Porter's Azure secrets plugin (via the sample porter config included) to resolve the values, while the others (`value`, `env`, etc.) utilize the local filesystem.

Prereqs to run:
 - Requires an Azure account
 - Create the keyvault listed in the sample Porter config (currently `my-keyvault`)
 - Place the sample Porter config in `~/.porter/config.toml` so Porter can use it
 - Create secrets for all of the referenced credentials and parameters in this keyvault (e.g. `porter-keyvault-resource-group`, `porter-keyvault-client-id`, etc.)
 - Execute this bundle with the credential and parameter sets supplied, e.g. 
 `porter install -p ./sample-paramset.json -c ./sample-credset.json`
