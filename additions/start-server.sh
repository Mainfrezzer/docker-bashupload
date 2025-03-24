#!/bin/sh
rm -f /var/run/apache2/apache2.pid
sleep 1
httpd  > /dev/null 2>&1
sleep 1
echo ---Cleaning old files---
php82 /app/tasks/clean.php
rm -rfv /app/files/tmp/*
sleep 1
echo ---...Started---
tail -f /var/log/apache2/access.log
