#!/bin/bash

DOMAIN="$1"

sed -i 's/localhost/'"$DOMAIN"'/g' ./configuration/conf.d/default.conf
echo "ssl_certificate /etc/nginx/ssl/live/"$DOMAIN"/fullchain.pem;" > ./configuration/shared/"$DOMAIN".conf
echo "ssl_certificate_key /etc/nginx/ssl/live/"$DOMAIN"/privkey.pem;" >> ./configuration/shared/"$DOMAIN".conf