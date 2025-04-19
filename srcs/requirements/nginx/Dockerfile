FROM alpine:3.20.6

RUN apk add --no-cache \
        nginx \
        openssl \
        tini \
        gettext

# Non‑root user (“www”) and basic dirs
RUN adduser -D -g 'www' www \
 && mkdir -p /www /var/cache/nginx \
 && chown -R www:www /www /var/cache/nginx

 # Nginx config & static files
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/index.html /www/

# Entrypoint script
COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 443

# tini becomes PID 1 → handles signals ↔ nginx quits cleanly
ENTRYPOINT ["/sbin/tini","--","docker-entrypoint.sh"]

# Default command ‑ may be overridden by `docker run … nginx -T`
CMD ["nginx","-g","daemon off;"]
