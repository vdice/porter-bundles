#!/usr/bin/env bash
set -euox pipefail

# TODO: use official chart from ghcr.io/brigadecore once published

prep-chart() {
  export HELM_EXPERIMENTAL_OCI=1
  helm3 chart pull ghcr.io/vdice/brigade-github-gateway:$1
  helm3 chart export ghcr.io/vdice/brigade-github-gateway:$1 -d ~/charts
}

install-chart() {
  prep-chart "$@"
  kubectl get namespace $3 || kubectl create namespace $3
  helm3 upgrade --install $2 /root/charts/brigade-github-gateway \
    --namespace $3 \
    --values /cnab/app/chart-values.yaml \
    --wait \
    --timeout 600s
}

delete-release() {
  helm3 delete $1 --namespace $2
  kubectl delete namespace $2
}

# Call the requested function and pass the arguments as-is
"$@"
