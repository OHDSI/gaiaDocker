#!/bin/bash

dpath=$(find /data -name "$1" -type d)
echo $dpath
deps=$(cat $dpath/meta_etl_$1.json | grep dependency)
if [[ ${#deps} -gt 0 ]]
then
  echo $deps | grep -o '\[[^][]*]' | sed 's/^.//;s/.$//' | awk -F',' '{for(i=1;i<=NF;i++) print $i}'
fi