#!/bin/bash

helm upgrade azureagent azureagent -i --set=image=cywl/azureagent:1.1-buildkit -set=azp_token=$(cat ../IaC/lib/agent_container/agent_azp_token.tfvars | awk '{print $3}' | tr -d '"')

#acrzt2fx0ax.azurecr.io/azureagent:1.1
#cywl/azureagent:1.1-buildkit
