FROM alpine:3.20.6

RUN adduser -D -H -s /sbin/nologin -G www-data www-data

ARG PHP_VERSION=83

RUN apk add --no-cache tini mariadb-client curl \
    php${PHP_VERSION} \
	php${PHP_VERSION}-mysqli \
	php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-curl \
	php${PHP_VERSION}-gd \
    php${PHP_VERSION}-intl \
	php${PHP_VERSION}-mbstring \
	php${PHP_VERSION}-soap \
	php${PHP_VERSION}-xml \
	php${PHP_VERSION}-zip \
	php${PHP_VERSION}-dom \
	php${PHP_VERSION}-exif \
    php${PHP_VERSION}-openssl \
	php${PHP_VERSION}-phar

# PHP‑FPM config
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php
COPY conf/www.conf /etc/php${PHP_VERSION}/php-fpm.d/www.conf

# Symlink the php${PHP_VERSION} to just php also for some scripts
RUN [ ! -e /usr/bin/php ] && ln -s /usr/bin/php${PHP_VERSION} /usr/bin/php || true
RUN [ ! -e /usr/bin/php-fpm ] && ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/bin/php-fpm || true
RUN echo "memory_limit = 512M" >> /etc/php${PHP_VERSION}/php.ini

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
CMD ["php-fpm", "-F"]
