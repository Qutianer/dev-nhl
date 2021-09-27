#!/bin/bash

pat=$(grep 'deploy_pat' devops.auto.tfvars  | cut -d ' ' -f3 | tr -d '"')
pat=$(echo -n ":$pat" | base64)
org="vujo3"
proj="project"


auth="Authorization: Basic $pat"
enc="Content-Type: application/json"
url="https://vsrm.dev.azure.com/$org/$proj/_apis/release/definitions?api-version=6.1-preview.4"

echo "$url"
# curl -d @build -u "admin:$pat" -H "$enc" "$url"

curl -d @build -H "$auth" -H "$enc" "$url"


