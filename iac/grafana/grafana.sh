#!/bin/bash

kubectl apply -f grafana.yaml

user='admin'
defpass='admin'
pass='ZAQ!xsw2'
server='grafana.nhl.appw.ru'

#server="$1"
#server="40.85.115.61"

#api_func="api/server/version"
#curl -sv "http://$server:9000/$api_func"

# [ "`curl -is "http://$server:9000/$api_func" | awk '/HTTP/{print $2}'`" == "200" ] && echo "yes" || echo "no"

# ret=`curl -s "http://$server:9000/$api_func"` && [ "$ret" != "9.1.0.47736" ] && echo "yes" || echo "no"

#test "$ret" != "" && echo "yes" || echo "no"

api_func="api/search"
while  [ "`curl -siu $user:$defpass "https://$server/$api_func" | awk '/HTTP/{print $2}'`" != "200" ]
do
 sleep 5
 echo -e "one more try"
done

echo "done"

sleep 5
echo
data="{\"oldPassword\": \"$defpass\", \"newPassword\": \"$pass\"}"
api_func="api/user/password"
curl -X PUT -H "Content-Type: application/json"  -siu $user:$defpass -d "$data" "https://$server/$api_func"
echo

subscr=`awk '/subscription_id/{ print $3 }' ../sp.auto.tfvars | tr -d '"'`
tenant=`awk '/tenant_id/{ print $3 }' ../sp.auto.tfvars | tr -d '"'`
client=`awk '/client_id/{ print $3 }' ../sp.auto.tfvars | tr -d '"'`
secret=`awk '/client_secret/{ print $3 }' ../sp.auto.tfvars | tr -d '"'`

data="{\"type\":\"grafana-azure-monitor-datasource\", \"name\": \"Azure Monitor\",\"access\":\"proxy\",\"isDefault\":true,\"jsonData\":{\"azureAuthType\":\"clientsecret\",\"clientId\":\"$client\",\"cloudName\":\"azuremonitor\",\"subscriptionId\":\"$subscr\",\"tenantId\":\"$tenant\"},\"secureJsonData\":{\"clientSecret\":\"$secret\"}}"
api_func="api/datasources"
curl -X POST -H "Content-Type: application/json" -d "$data" -siu $user:$pass "https://$server/$api_func"
echo
api_func="api/dashboards/db"
curl -X POST -H "Content-Type: application/json" -d@dashboard.json -siu $user:$pass "https://$server/$api_func"
echo
