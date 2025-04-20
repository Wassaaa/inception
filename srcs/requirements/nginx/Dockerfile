FROM alpine:3.20.6

RUN apk add --no-cache \
        nginx \
        openssl \
        tini \
        gettext

# Nginx config
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Entrypoint script
COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/sbin/tini","--","docker-entrypoint.sh"]
CMD ["nginx","-g","daemon off;"]
