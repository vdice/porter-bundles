#!/bin/sh

params="ainteger astringenum astring aboolean installonly sensitive jsonobject"

for param in $params; do
  env_var="${param^^}"
  echo "  ${param}: ${!env_var}"
done