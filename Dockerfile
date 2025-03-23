FROM alpine:latest
ENV UPLOADSIZE="128M"
ENV USER="bashupload"
ENV UID="99"
ENV GID="100"
RUN apk add --no-cache nginx php82 php82-fpm shadow tzdata

RUN mkdir -p /run/nginx /app /src

ADD https://github.com/IO-Technologies/bashupload.git /src

RUN sed -i 's|/etc/mime.types|/etc/nginx/mime.types|' /src/lib.php \
&& sed -i 's|/var/files/tmp|/app/files|' /src/actions/upload.php \
&& sed -i 's|/var/files|/app/files|' /src/config.local.php \
&& sed -i "s|define('FORCE_SSL', true);|define('FORCE_SSL', false);|" /src/config.local.php \
&& sed -i 's|max_execution_time = 30|max_execution_time = 1800|' /etc/php82/php.ini



COPY additions/ /

RUN deluser --remove-home games && deluser --remove-home guest \
&& delgroup users \
&& adduser -D ${USER}

EXPOSE 80

ENTRYPOINT ["/start.sh"]
