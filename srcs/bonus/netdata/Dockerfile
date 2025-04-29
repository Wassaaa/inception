FROM alpine:3.20.6

RUN apk add --no-cache netdata tzdata tini

RUN mkdir -p /etc/netdata \
    && printf '[web]\n  bind to = 0.0.0.0\n' > /etc/netdata/netdata.conf

# Copy entrypoint script
COPY ./entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 19999

ENTRYPOINT ["/sbin/tini","--","docker-entrypoint.sh"]
CMD ["netdata", "-D"]
