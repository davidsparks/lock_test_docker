#!/bin/bash

SELF_DIRNAME="$(cd $(dirname -- "$0") && pwd)"

source ${SELF_DIRNAME}/../.env

command="$1"

php_version_dot=$(docker exec ${PROJECT_NAME}_php php -r "\$v=explode('.', phpversion() ); echo implode('.', array_splice(\$v, 0, -1));")
php_version="${php_version_dot//./}"

xdebug_conf="/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"

if [ "$command" == "on" ]; then
    docker exec ${PROJECT_NAME}_php mv "$xdebug_conf.disabled" "$xdebug_conf" 2> /dev/null
    STATUS="enabled"
elif [ "$command" == "off" ]; then
    docker exec ${PROJECT_NAME}_php mv "$xdebug_conf" "$xdebug_conf.disabled" 2> /dev/null
    STATUS="disabled"
fi

echo ""
echo "Xdebug has been ${STATUS}, restarting nginx"

docker exec ${PROJECT_NAME}_php sudo kill -USR2 1

echo ""
echo "You are running PHP v$php_version_dot with Xdebug ${STATUS}"
echo ""
