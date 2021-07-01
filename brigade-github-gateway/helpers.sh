#!/usr/bin/env bash
set -euox pipefail

prep-chart() {
  export HELM_EXPERIMENTAL_OCI=1
  helm3 chart pull ghcr.io/brigadecore/brigade-github-gateway:$1
  helm3 chart export ghcr.io/brigadecore/brigade-github-gateway:$1 -d ~/charts
}

install-chart() {
  prep-chart "$@"

  kubectl get namespace $3 || kubectl create namespace $3

  # TODO: enable with the rest of the sa automation
  # # Use the api token if it has been generated
  # # (from setting up the service account)
  # apiToken="$(cat /cnab/app/outputs/service-account-token)"
  # setApiToken=""
  # if [[ "${apiToken}" != "" ]]; then
  #   setApiToken="--set brigade.apiToken=${apiToken}"
  # fi

  helm3 upgrade --install $2 /root/charts/brigade-github-gateway \
    --namespace $3 \
    --values /cnab/app/chart-values.yaml \
    --wait \
    --timeout 600s
    # "${setApiToken}"
}

delete-release() {
  helm3 delete $1 --namespace $2
  kubectl delete namespace $2
}

setup-service-account() {
  mkdir -p /cnab/app/outputs

  # TODO: needs next release of brig to get -o json here
  brig service-account create \
      --id $1 \
      --description $1 \
      -o json | jq -r '.value' > /cnab/app/outputs/service-account-token

  brig role grant READER \
      --service-account $1

  brig role grant EVENT_CREATOR \
      --service-account $1 \
      --source brigade.sh/github
}

# Call the requested function and pass the arguments as-is
"$@"
