#!/bin/sh
if [ -z "$(find /app -mindepth 1 -not -path '/app/files*' -print -quit)" ]; then
  echo ---Setting up app---
  cp -r /src/* /app
fi

if [ ! -d /app/files/tmp ]; then
mkdir /app/files/tmp
fi
#Temporary fix and migration, reinstall of the app should be done at some point
sed -i '
s|/etc/mime.types|/etc/apache2/mime.types|;
s|/etc/nginx/mime.types|/etc/apache2/mime.types|
' /app/lib.php

#Thanks apache

convert_to_bytes() {
    local size="$1"
    local unit="${size: -1}"
    local value="${size:0:${#size}-1}"

    case "$unit" in
	T)  echo $((value * 1024 * 1024 * 1024 * 1024))	;;
	G)  echo $((value * 1024 * 1024 * 1024))	;; 
	M)  echo $((value * 1024 * 1024))		;;
	K)  echo $((value * 1024))			;;
	*)  echo "$value"				;;
    esac
}

UPLOADSIZE_BYTES=$(convert_to_bytes "$UPLOADSIZE")



sed -i "
s/LimitRequestBody .*/LimitRequestBody ${UPLOADSIZE_BYTES}/;
s/post_max_size = .*/post_max_size = ${UPLOADSIZE}/;
s/upload_max_filesize = .*/upload_max_filesize = ${UPLOADSIZE}/
" /etc/apache2/httpd.conf /etc/php82/php.ini

groupmod --gid ${GID} ${USER} > /dev/null
usermod --uid ${UID} --gid ${GID} ${USER} > /dev/null
chown -R ${USER}:${USER} /app

mkdir -p /run/apache2 && chown -R ${USER}:${USER} /run/apache2
chown -R ${USER}:${USER} /var/log/apache2

echo "---Starting...---"
term_handler() {
	kill -SIGTERM "$killpid"
	wait "$killpid" -f 2>/dev/null
	exit 143;
}

trap 'kill ${!}; term_handler' SIGTERM
sh -c crond
su ${USER} -c "/start-server.sh" &
killpid="$!"
while true
do
	wait $killpid
	exit 0;
done
