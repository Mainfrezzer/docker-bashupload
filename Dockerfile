FROM alpine:latest
ENV UPLOADSIZE="128M"
ENV USER="bashupload"
ENV UID="99"
ENV GID="100"

RUN apk add --no-cache nginx php82 php82-fpm shadow tzdata

RUN mkdir -p /run/nginx /app /source

COPY default.conf /etc/nginx/http.d/default.conf
COPY src/ /source
COPY additions/ /

RUN deluser --remove-home games && deluser --remove-home guest \
&& delgroup users \
&& adduser -D ${USER}

EXPOSE 80

ENTRYPOINT ["/start.sh"]
