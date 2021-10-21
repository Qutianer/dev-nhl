#!/bin/bash

dt=$(date)
#terraform init
terraform apply -auto-approve
jq --slurpfile vars devops_vars.tfvars -f jq_filter_dev release-dev-v5-src.json >release-dev-v5.json
./api_add.sh release-dev-v5.json >/dev/null
jq --slurpfile vars devops_vars.tfvars -f jq_filter_prod release-prod-v5-src.json >release-prod-v5.json
./api_add.sh release-prod-v5.json >/dev/null

#ansible-playbook main.yaml

cp -f k8s_dev_config.tfvars ~/.kube/config
pushd azureagent
./helm.sh
popd

./queue.sh `jq ".fe_dev" devops_vars.tfvars | tr -d '"'`
./queue.sh `jq ".be_dev" devops_vars.tfvars | tr -d '"'`
./queue.sh `jq ".helm_dev" devops_vars.tfvars | tr -d '"'`

pushd ..
#./trigger.sh front-end
#./trigger.sh back-end
#./trigger.sh helm
#./comment.sh 'initial deploy'
popd

echo $dt
date

