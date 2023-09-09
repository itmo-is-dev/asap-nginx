FROM nginx:latest
RUN apt update && apt install jq curl apache2-utils -y
COPY ./configuration /etc/nginx
RUN openssl dhparam -dsaparam -out /etc/nginx/dhparam.pem 4096

ENTRYPOINT entrypoint.sh