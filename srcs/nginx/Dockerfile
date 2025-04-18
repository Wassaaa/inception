FROM alpine:3.21.3
RUN apk update && apk add --no-cache nginx
RUN adduser -D -g 'www' www
RUN mkdir /www && chown -R www:www /var/lib/nginx && chown -R www:www /www
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY conf/nginx.conf /etc/nginx
COPY conf/index.html /www
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
