#!/bin/bash

dt=$(date)
terraform init
terraform apply -auto-approve
./jq_filter.sh release-v4-src.json >release-v4.json
./api_add.sh release-v4.json


#ansible-playbook main.yaml

#client_id=$( sed -rne '/client_id/s/.*= \"(.*)\"/\1/gp' terraform.tfvars )


