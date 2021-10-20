#!/bin/bash

user='admin'
defpass='admin'
pass='ZAQ!xsw2'
server=`sed -ne '2p' inventory`
#server="$1"
#server="40.85.115.61"

#api_func="api/server/version"
#curl -sv "http://$server:9000/$api_func"

# [ "`curl -is "http://$server:9000/$api_func" | awk '/HTTP/{print $2}'`" == "200" ] && echo "yes" || echo "no"

# ret=`curl -s "http://$server:9000/$api_func"` && [ "$ret" != "9.1.0.47736" ] && echo "yes" || echo "no"

#test "$ret" != "" && echo "yes" || echo "no"

api_func="api/server/version"
while  [ "`curl -is "http://$server:9000/$api_func" | awk '/HTTP/{print $2}'`" != "200" ]
do
 sleep 5
 echo -e "one more try"
done

echo "done"

sleep 10

data="login=admin&password=$pass&previousPassword=$defpass"
api_func="api/users/change_password"
curl -X POST -svu $user:$defpass "http://$server:9000/$api_func?$data"

sleep 10

data="name=nhl&project=nhl"
api_func="api/projects/create"
curl -X POST -svu $user:$pass "http://$server:9000/$api_func?$data"

data="name=nhl"
api_func="api/user_tokens/generate"
token=`curl -X POST -svu $user:$pass "http://$server:9000/$api_func?$data" | jq .token | tr -d '"'`
#echo "sonar_server = \"http://$server:9000\"" >../sonar.auto.tfvars
echo "sonar_server = \"http://sonar:9000\"" >../sonar.auto.tfvars
echo "sonar_pat = \"$token\"" >>../sonar.auto.tfvars

# token=`echo '{"login":"admin","name":"nhl","token":"ca73bcc7371dbac571c4ff7f43ce0f626cc324ce","createdAt":"2021-10-16T13:46:58+0000"}' | jq .token | tr -d '"'`
