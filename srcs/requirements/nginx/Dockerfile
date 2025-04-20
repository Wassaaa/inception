FROM alpine:3.20.6

RUN adduser -D -H -s /sbin/nologin -G www-data www-data

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

# tini becomes PID 1 → handles signals ↔ nginx quits cleanly
ENTRYPOINT ["/sbin/tini","--","docker-entrypoint.sh"]

# Default command ‑ may be overridden by `docker run … nginx -T`
CMD ["nginx","-g","daemon off;"]
