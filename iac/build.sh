echo -n "fe_dev..."
./queue.sh `jq ".fe_dev" devops_vars.tfvars | tr -d '"'` >/dev/null
echo "done"
echo -n "be_dev..."
./queue.sh `jq ".be_dev" devops_vars.tfvars | tr -d '"'` >/dev/null
echo "done"
echo -n "helm_dev..."
./queue.sh `jq ".helm_dev" devops_vars.tfvars | tr -d '"'` >/dev/null
echo "done"

