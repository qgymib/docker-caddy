FROM alpine
LABEL maintainer "Q.GY <qgymib@gmail.com>"

ARG BUILD_DEPS="bash curl"
ARG WEB_DEFAULT_PATH=/data/www/default
ENV CADDYPATH=/data/caddy

RUN mkdir -p $CADDYPATH/conf.d && mkdir -p $WEB_DEFAULT_PATH \
    && apk add --no-cache $BUILD_DEPS \
    && CADDY_TELEMETRY=on curl https://getcaddy.com | bash -s personal http.cache,http.cors,http.expires,http.filemanager,http.realip \
    && echo -e ":80 {\n    gzip\n    root $WEB_DEFAULT_PATH\n}\n\nimport conf.d/*.conf" > $CADDYPATH/caddy.conf \
    && apk del --no-cache $BUILD_DEPS \
    && caddy -version && caddy -plugins

COPY index.html $WEB_DEFAULT_PATH/

EXPOSE 80 443 2015

CMD ["caddy", "-conf", "/data/caddy/caddy.conf", "-log", "stdout", "-root", "/tmp", "-agree"]
