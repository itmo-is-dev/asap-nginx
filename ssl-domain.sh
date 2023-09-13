#!/bin/bash

DOMAIN="$1"
FULLCHAIN_FILE_COUNT=$(sudo git ls-files . --exclude-standard --others | grep live/"$DOMAIN"/full | wc -l)

if [ $FULLCHAIN_FILE_COUNT -eq 1 ]
then
	sed -i 's/localhost/'"$DOMAIN"'/g' ./configuration/conf.d/default.conf
	echo "ssl_certificate /etc/nginx/ssl/live/"$DOMAIN"/fullchain.pem;" > ./configuration/shared/"$DOMAIN".conf
	echo "ssl_certificate_key /etc/nginx/ssl/live/"$DOMAIN"/privkey.pem;" >> ./configuration/shared/"$DOMAIN".conf
	echo "certificate-provider=letsencrypt" >> $GITHUB_OUTPUT
else
	echo "certificate-provider=self-signed" >> $GITHUB_OUTPUT
fi