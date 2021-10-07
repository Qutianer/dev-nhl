#!/bin/bash

if [ "$1" == "" ]; then
  echo "Please, specify json to load"
  exit 1
fi

var_file="api_pat.tfvars"
pat=$(grep 'deploy_pat' "$var_file"  | cut -d ' ' -f3)
pat=$(echo -n ":$pat" | base64)
org="vujo3"
proj="nhl"


auth="Authorization: Basic $pat"
enc="Content-Type: application/json"
url="https://vsrm.dev.azure.com/$org/$proj/_apis/release/definitions?api-version=6.0"

#echo "$url"
# curl -d @build -u "admin:$pat" -H "$enc" "$url"

curl -d @$1 -H "$auth" -H "$enc" "$url"


