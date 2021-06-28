#!/bin/sh

params="integer string multilinestring enum boolean installonly sensitive objectstring object array"
for param in $params; do
  env_var="${param^^}"
  echo "  ${param}: ${!env_var}"
done