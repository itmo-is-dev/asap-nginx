#!/bin/bash

export IAM_TOKEN=$(curl -H Metadata-Flavor:Google http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token -s | jq -r .access_token)
export HTUSERNAME=$(curl -X GET -H "Authorization: Bearer $IAM_TOKEN" https://payload.lockbox.api.cloud.yandex.net/lockbox/v1/secrets/e6q64n48stn4bu3ot758/payload -s | jq '(.entries[] | select( .key == "kafka-ui-user")).textValue' -r)
export HTPASSWORD=$(curl -X GET -H "Authorization: Bearer $IAM_TOKEN" https://payload.lockbox.api.cloud.yandex.net/lockbox/v1/secrets/e6q64n48stn4bu3ot758/payload -s | jq '(.entries[] | select( .key == "kafka-ui-password")).textValue' -r)
export EXTERNAL_IP=$(curl -H Metadata-Flavor:Google 169.254.169.254/computeMetadata/v1/instance/network-interfaces/?recursive=true -s | jq '.[].accessConfigs[].externalIp' -r)

htpasswd -c -b /etc/nginx/.htpasswd $HTUSERNAME $HTPASSWORD 

openssl req -new -newkey rsa:2048 -sha256 -nodes -keyout /tmp/https.key -subj "/CN=$EXTERNAL_IP\/emailAddress=admin@$EXTERNAL_IP/C=US/ST=Ohio/L=Columbus/O=ASAP/OU=NGINX" -out /tmp/https.csr \
&& openssl req -inform PEM -in /tmp/https.csr -out /tmp/https.pem \
&& openssl x509 -req -in /tmp/https.pem -signkey /tmp/https.key -out /tmp/https.crt

mv /tmp/https.{key,crt} /etc/nginx/

nginx -g 'daemon off;'