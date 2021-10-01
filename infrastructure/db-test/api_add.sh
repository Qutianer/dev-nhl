#!/bin/bash

if [ "$1" == "" ]; then
  echo "Please, specify json to load"
  exit 1
fi

pat=$(grep 'deploy_pat' devops.auto.tfvars  | cut -d ' ' -f3 | tr -d '"')
pat=$(echo -n ":$pat" | base64)
org="vujo3"
proj="project"


auth="Authorization: Basic $pat"
enc="Content-Type: application/json"
url="https://vsrm.dev.azure.com/$org/$proj/_apis/release/definitions?api-version=6.0"

#echo "$url"
# curl -d @build -u "admin:$pat" -H "$enc" "$url"

curl -d @$1 -H "$auth" -H "$enc" "$url"


