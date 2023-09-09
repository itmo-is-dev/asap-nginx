export EXTERNAL_IP=$(curl -H Metadata-Flavor:Google 169.254.169.254/computeMetadata/v1/instance/network-interfaces/?recursive=true | jq '.[].accessConfigs[].externalIp' -r)

openssl req -new -newkey rsa:2048 -sha256 -nodes -keyout /tmp/https.key -subj "/CN=$EXTERNAL_IP\/emailAddress=admin@$EXTERNAL_IP/C=US/ST=Ohio/L=Columbus/O=ASAP/OU=NGINX" -out /tmp/https.csr \
&& openssl req -inform PEM -in /tmp/https.csr -out /tmp/https.pem \
&& openssl x509 -req -in /tmp/https.pem -signkey /tmp/https.key -out /tmp/https.crt

mv /tmp/https.{key,crt} /etc/nginx/

nginx -g daemon off;