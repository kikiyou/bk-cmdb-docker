#!/bin/bash
set -e

if [ ! -f '/data/init' ];then
    cd /opt/nginx/html
    /opt/php/bin/php index.php /cli/Init/initUserData
    cd -
    touch /data/init
fi

if [ "${1#-}" != "${1}" ]; then
    /opt/php/sbin/php-fpm -y /opt/php/etc/php-fpm.conf.default
    set -- /opt/nginx/sbin/nginx "${@}"
fi

exec "${@}"
