#!/bin/sh
if [ -z "$(find /app -mindepth 1 -not -path '/app/files*' -print -quit)" ]; then
  echo ---Setting up app---
  cp -r /src/* /app
fi

sed -i "
s/client_max_body_size .*;/client_max_body_size ${UPLOADSIZE};/;
s/post_max_size = .*/post_max_size = ${UPLOADSIZE}/;
s/upload_max_filesize = .*/upload_max_filesize = ${UPLOADSIZE}/
" /etc/nginx/http.d/default.conf /app/web/.user.ini

groupmod --gid ${GID} ${USER} > /dev/null
usermod --uid ${UID} --gid ${GID} ${USER} > /dev/null
chown -R ${USER}:${USER} /app

mkdir -p /run/nginx && chown -R ${USER}:${USER} /run/nginx
chown -R ${USER}:${USER} /var/log/nginx && chown -R ${USER}:${USER} /var/lib/nginx
chown -R ${USER}:${USER} /var/log/php82

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
