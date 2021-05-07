A collection of [Porter] bundles.

Follow the [Porter] docs for installation steps, etc.

Then try out some of these bundles!

### Create credentials for a bundle
```
 $ porter creds generate --reference ghcr.io/vdice/cert-manager:v0.1.0
Generating new credential cert-manager from bundle cert-manager
==> 1 credentials required for bundle cert-manager
? How would you like to set credential "kubeconfig"
  file path
? Enter the path that will be used to set credential "kubeconfig"
  /path/to/my/kubeconfig
```

### Create parameters for a bundle
```
 $ porter params generate --reference ghcr.io/vdice/cert-manager:v0.1.0
Generating new parameter set cert-manager from bundle cert-manager
==> 4 parameters declared for bundle cert-manager
? How would you like to set parameter "chart-values"
  specific value
? Enter the value that will be used to set parameter "chart-values"
  {}
? How would you like to set parameter "issuer-prod"
  file path
? Enter the path that will be used to set parameter "issuer-prod"
  /path/to/my/cert-manager-issuer-prod.yaml
? How would you like to set parameter "issuer-staging"
  file path
? Enter the path that will be used to set parameter "issuer-staging"
  /path/to/my/cert-manager-issuer-staging.yaml
```

### Install a bundle with the generated creds and params
```
 $ porter install --reference ghcr.io/vdice/cert-manager:v0.1.0 -c cert-manager -p cert-manager
installing cert-manager...
executing install action from cert-manager (installation: cert-manager)
Create cert-manager namespace
namespace/cert-manager created
Helm Install Cert Manager
/usr/local/bin/helm3 helm3 upgrade --install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.1.1 --wait --values /cnab/app/chart-values.yaml --set installCRDs=true
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: *******
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: *******
Release "cert-manager" does not exist. Installing it now.
NAME: cert-manager
LAST DEPLOYED: Fri May  7 17:34:19 2021
NAMESPACE: cert-manager
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
cert-manager has been deployed successfully!
In order to begin issuing certificates, you will need to set up a ClusterIssuer
or Issuer resource (for example, by creating a 'letsencrypt-staging' issuer).
More information on the different types of issuers and how to configure them
can be found in our documentation:
https://cert-manager.io/docs/configuration/
For information on how to configure cert-manager to automatically provision
Certificates for Ingress resources, take a look at the `ingress-shim`
documentation:
https://cert-manager.io/docs/usage/ingress/
Install Issuers
clusterissuer.cert-manager.io/letsencrypt-staging created
clusterissuer.cert-manager.io/letsencrypt-prod created
execution completed successfully!
```

### Uninstall a bundle
```
 $ porter uninstall --reference ghcr.io/vdice/cert-manager:v0.1.0 -c cert-manager -p cert-manager
uninstalling cert-manager...
executing uninstall action from cert-manager (installation: cert-manager)
Uninstall Issuers
clusterissuer.cert-manager.io "letsencrypt-staging" deleted
clusterissuer.cert-manager.io "letsencrypt-prod" deleted
Helm Uninstall Cert Manager
/usr/local/bin/helm3 helm3 uninstall cert-manager --namespace cert-manager
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: *******
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: *******
release "cert-manager" uninstalled
Delete cert-manager namespace
namespace "cert-manager" deleted
execution completed successfully!
```

[Porter]: https://porter.sh
