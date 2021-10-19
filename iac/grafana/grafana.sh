#!/bin/bash

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
while  [ "`curl -is "http://$server/$api_func" | awk '/HTTP/{print $2}'`" != "200" ]
do
 sleep 5
 echo -e "one more try"
done

echo "done"

sleep 5

data="{\"oldPassword\": \"$defpass\", \"newPassword\": \"$pass\"}"
api_func="/api/user/password"
curl -X POST -svu $user:$defpass -d "$data" "http://$server/$api_func"


