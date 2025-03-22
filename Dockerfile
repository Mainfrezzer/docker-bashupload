FROM alpine:latest
ENV UPLOADSIZE="128M"
ENV USER="bashupload"
ENV UID="99"
ENV GID="100"
RUN apk add --no-cache nginx php82 php82-fpm shadow tzdata

RUN mkdir -p /run/nginx /app /src

ADD https://github.com/IO-Technologies/bashupload.git /src
COPY additions/ /

RUN deluser --remove-home games && deluser --remove-home guest \
&& delgroup users \
&& adduser -D ${USER}

EXPOSE 80

ENTRYPOINT ["/start.sh"]
