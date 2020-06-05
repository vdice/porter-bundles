#!/bin/sh

# Create the docker secret if not already present
docker secret ls | grep my_created_secret || \
  echo $MY_SECRET | docker secret create my_created_secret -
