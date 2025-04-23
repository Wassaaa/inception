FROM alpine:3.20.6

ARG PHP_VERSION=83

RUN apk add --no-cache tini mariadb-client wget \
    php${PHP_VERSION} \
	php${PHP_VERSION}-mysqli \
	php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-json \
	php${PHP_VERSION}-session \
	php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-openssl


# PHP‑FPM config
COPY conf/www.conf /etc/php${PHP_VERSION}/php-fpm.d/www.conf

# Symlink the php${PHP_VERSION} to just php for some scripts
RUN [ ! -e /usr/bin/php ] && ln -s /usr/bin/php${PHP_VERSION} /usr/bin/php || true
RUN [ ! -e /usr/bin/php-fpm ] && ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/bin/php-fpm || true
RUN echo "memory_limit = 256M" >> /etc/php${PHP_VERSION}/php.ini

RUN mkdir -p /var/www/html && \
    wget "http://www.adminer.org/latest.php" -O /var/www/html/index.php

RUN adduser -D -H -s /sbin/nologin -G www-data adminer \
 && mkdir -p /var/www/html \
 && chown -R adminer:www-data /var/www/html

COPY ./entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/sbin/tini","--","docker-entrypoint.sh"]
CMD ["php-fpm", "-F"]
