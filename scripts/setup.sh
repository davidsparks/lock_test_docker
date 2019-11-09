#!/bin/bash

SELF_DIRNAME="$(cd $(dirname -- "$0") && pwd)"
source ${SELF_DIRNAME}/../.env

# Extra config for Nginx to allow background_process to work properly [fastcgi_ignore_client_abort on;]
docker exec ${PROJECT_NAME}_nginx bash -c "cat /var/www/cnf/extra.conf >> /etc/nginx/preset.conf"
docker exec ${PROJECT_NAME}_nginx sudo nginx -s reload

# Xdebug off
scripts/xdebug-toggle.sh off

