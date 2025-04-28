FROM alpine:3.20.6

RUN apk add --no-cache \
        nginx \
        tini

COPY site/ /usr/share/nginx/html
RUN rm -f /etc/nginx/http.d/*.conf
COPY conf/ /etc/nginx/http.d

# Entrypoint script
COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/sbin/tini","--","docker-entrypoint.sh"]
CMD ["nginx","-g","daemon off;"]
