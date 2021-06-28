#!/usr/bin/env bash
set -euox pipefail

prep-project() {
  export project=$1
  yq e -i '.metadata.id = env(project)' /cnab/app/project.yaml
}

# Call the requested function and pass the arguments as-is
"$@"
