#!/usr/bin/env bash
set -euo pipefail

create_data_volume() {
  # Create Docker volume for mounting data into app container
  docker volume ls | grep cnab-app-volume || \
    docker volume create cnab-app-volume

  # Add files from /cnab/app to volume via a helper container
  docker run -v cnab-app-volume:/data --name helper busybox true
  docker cp /cnab/app/echo.txt helper:/data
  docker rm helper > /dev/null
}

create_docker_host_volume() {
  # Create Docker volume for mounting data from app container to host
  # Using the supplied host volume path as the device arg
  docker volume ls | grep docker-host-volume || \
    docker volume create -o type=none -o o=bind -o device=$1 docker-host-volume
}

create_docker_volumes() {
  create_data_volume
  create_docker_host_volume $1
}

update_docker_volumes() {
  create_data_volume
  create_docker_host_volume $1
}

remove_docker_volumes() {
  docker volume rm cnab-app-volume
  docker volume rm docker-host-volume
}

print_app_logs() {
  docker run -v docker-host-volume:/logs --name logreader busybox awk 1 /logs/echo.txt
  docker rm logreader > /dev/null
}

# Call the requested function and pass the arguments as-is
"$@"