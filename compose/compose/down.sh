#!/bin/bash

set -euo pipefail

cd compose
docker-compose down --remove-orphans