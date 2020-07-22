#!/bin/sh

params="AINTEGER ASTRINGENUM ASTRING ABOOLEAN INSTALLONLY SENSITIVE JSONOBJECT"

for param in $params; do
  echo "${!param}"
done