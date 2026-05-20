FROM alpine:latest
ENV UPLOADSIZE="128M"
ENV USER="bashupload"
ENV UID="99"
ENV GID="100"
ENV PHPV="php85"
RUN apk add --no-cache apache2 ${PHPV}-apache2 ${PHPV} shadow tzdata

RUN mkdir -p /run/apache2 /app /src

ADD https://github.com/Mainfrezzer/bashupload.git#docker-container /src

RUN sed -i 's|max_execution_time = 30|max_execution_time = 1800|' /etc/${PHPV}/php.ini \
&& sed -i 's|;sys_temp_dir = "/tmp"|sys_temp_dir = "/app/files/tmp"|' /etc/${PHPV}/php.ini
COPY additions/ /

RUN deluser --remove-home games && deluser --remove-home guest \
&& delgroup users \
&& adduser -D ${USER}

EXPOSE 80

ENTRYPOINT ["/start.sh"]
