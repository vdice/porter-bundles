#!/usr/bin/env bash
set -euox pipefail

create_docker_volume() {
  # Create Docker volume if it doesn't already exist
  docker volume ls | grep myvol || \
    docker volume create myvol

  # Add files to volume via a helper container
  docker run -v myvol:/data --name helper busybox true
  # Could copy the entire app directory in
  # docker cp /cnab/app helper:/data
  docker cp /cnab/app/echo.txt helper:/data
  docker cp /cnab/app/config.toml helper:/data
  docker rm helper
}

print_app_logs() {
  docker logs app_hello_1
}

# Call the requested function and pass the arguments as-is
"$@"