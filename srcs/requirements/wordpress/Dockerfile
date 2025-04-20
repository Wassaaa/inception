FROM alpine:3.20.6

RUN adduser -D -H -s /sbin/nologin -g www-data www-data

RUN apk add --no-cache tini mariadb-client curl \
    php82 \
	php82-mysqli \
	php82-fpm \
    php82-curl \
	php82-gd \
    php82-intl \
	php82-mbstring \
	php82-soap \
	php82-xml \
	php82-xmlrpc \
	php82-zip \
	php82-dom \
	php82-exif \
    php82-openssl \
	php82-phar

# PHP‑FPM config
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

# Copy entrypoint script
COPY ./entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000

# download and symlink wp-cli to wp
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        -O /usr/local/bin/wp-cli.phar \
 && chmod +x /usr/local/bin/wp-cli.phar \
 && ln -s /usr/local/bin/wp-cli.phar /usr/local/bin/wp

# tini becomes PID 1 → handles signals ↔ nginx quits cleanly
ENTRYPOINT ["/sbin/tini","--","docker-entrypoint.sh"]
# Default command ‑ may be overridden by `docker run … nginx -T`
CMD ["php-fpm83", "-F"]
