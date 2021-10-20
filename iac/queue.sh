#!/bin/bash

build_id="$1"

var_file="api_pat.tfvars"
pat=$(grep 'deploy_pat' "$var_file"  | cut -d ' ' -f3)
pat=$(echo -n ":$pat" | base64)
org="vujo3"
proj="nhl"

auth="Authorization: Basic $pat"
enc="Content-Type: application/json"

#echo "$url"
# curl -d @build -u "admin:$pat" -H "$enc" "$url"

url="https://dev.azure.com/$org/$proj/_apis/build/builds?api-version=6.0&definitionId=$build_id"
curl -X POST -s -H "$auth" -d '' -H "$enc" "$url"

