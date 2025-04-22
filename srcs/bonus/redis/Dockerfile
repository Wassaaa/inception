FROM alpine:3.20.6

RUN apk add --no-cache redis php-redis tini

# Copy entrypoint script
COPY ./entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY ./conf/redis.conf /etc/redis.conf

EXPOSE 6379

ENTRYPOINT ["/sbin/tini","--","docker-entrypoint.sh"]
CMD ["redis-server", "/etc/redis.conf"]
