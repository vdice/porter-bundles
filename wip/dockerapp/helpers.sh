#!/usr/bin/env bash
set -euo pipefail

create_volume() {
  # Create the docker volume if not already present
  docker volume ls | grep myvol || \
    docker volume create myvol
}

# Call the requested function and pass the arguments as-is
"$@"