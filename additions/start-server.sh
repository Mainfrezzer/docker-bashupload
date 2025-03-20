#!/bin/sh
php-fpm82 > /dev/null 2>&1
nginx -g 'daemon off;' > /dev/null 2>&1 &
sleep 1
echo ---Cleaning old files---
php82 /app/tasks/clean.php
sleep 1
echo ---...Started---
tail -f /var/log/nginx/access.log
