#!/bin/bash

dt=$(date)
terraform init
terraform apply -auto-approve
jq --slurpfile vars devops_vars.tfvars -f jq_filter_dev release-dev-v5-src.json >release-dev-v5.json
./api_add.sh release-dev-v5.json
jq --slurpfile vars devops_vars.tfvars -f jq_filter_prod release-prod-v5-src.json >release-prod-v5.json
./api_add.sh release-prod-v5.json

#ansible-playbook main.yaml

cp -f k8s_dev_config.tfvars ~/.kube/config
pushd ../../azureagent
./helm.sh
popd

pushd ../..
./trigger.sh front-end
./trigger.sh back-end
./trigger.sh helm
../comment.sh 'initial deploy'
popd

echo $dt
date
