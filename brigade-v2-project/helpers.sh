#!/usr/bin/env bash
set -euo pipefail

get-project-name() {
  printf $(yq e '.metadata.id' /cnab/app/project.yaml) > /cnab/app/project-name
}

# Call the requested function and pass the arguments as-is
"$@"
