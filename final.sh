#!/bin/bash -v

function usage {
        echo " Usage:"
        echo " $0 FQDN"
        echo ""
}

if [ -z $1 ]
then
    usage
exit
fi

source $(dirname "$0")/.key

ZONE=$1
TOKEN=$(curl -s -X POST 'https://panel.netangels.ru/api/gateway/token/' \
-d "api_key=$KEY" \
| tr '"' ' ' | tr '\n' ' ' | awk '{print $4}')
#echo "$TOKEN" | cat -v # debug, apparently there was a newline in the token and curl went crazy
ID=$(curl -s -H "Authorization: Bearer $TOKEN" -X GET "https://api-ms.netangels.ru/api/v1/certificates/find/?domains=$ZONE" \
| grep \"id\" | awk '{print $2}' | sed 's/,//')
#echo $ID
#echo DLing cert
curl -H "Authorization: Bearer $TOKEN" -X GET "https://api-ms.netangels.ru/api/v1/certificates/$ID/download/?name=$ZONE&type=tar" \
-o ~/$ZONE.tar

