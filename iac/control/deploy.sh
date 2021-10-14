#!/bin/bash

terraform init
terraform apply -auto-approve
ansible-playbook main.yaml
