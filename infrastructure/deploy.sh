#!/bin/bash

terraform init
terraform apply -auto-approve
ansible-playbook main.yaml

#client_id=$( sed -rne '/client_id/s/.*= \"(.*)\"/\1/gp' terraform.tfvars )


