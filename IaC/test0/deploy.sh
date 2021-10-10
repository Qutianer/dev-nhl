#!/bin/bash

dt=$(date)
terraform init
terraform apply -auto-approve
./jq_filter.sh release-v5-src.json >release-v5.json
./api_add.sh release-v5.json


#ansible-playbook main.yaml

#client_id=$( sed -rne '/client_id/s/.*= \"(.*)\"/\1/gp' terraform.tfvars )

cp -f k8s_dev_config.tfvars ~/.kube/config


echo $dt
date
