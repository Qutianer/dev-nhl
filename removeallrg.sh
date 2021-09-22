for rg in $(az group list -o tsv | cut -f4); do az group delete --no-wait -y -g $rg; done
