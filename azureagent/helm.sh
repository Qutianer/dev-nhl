helm upgrade azureagent azureagent -i --set=image=acrzt2fx0ax.azurecr.io/azureagent:1.1 -set=azp_token=$(cat ../IaC/lib/agent_container/agent_azp_token.tfvars | awk '{print $3}' | tr -d '"')
