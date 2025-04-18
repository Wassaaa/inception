FROM alpine:3.20.6
RUN apk add --no-cache tini mariadb-client \
    php83 \
	php83-fpm \
    # WordPress required
	php83-phar \
    php83-curl \
	php83-mysqli \
	php83-iconv \
	php83-json \
	php83-dom \
	php83-xml \
	php83-exif \
    php83-openssl \
	php83-zip \
    # Recommended extras
    php83-intl \
	php83-mbstring \
	php83-gd \
	php83-fileinfo \
    php83-session

# Configure PHP‑FPM to listen on port 9000 and set user to match nginx
RUN sed -i 's|listen = .*|listen = 9000|' /etc/php83/php-fpm.d/www.conf
RUN sed -i 's|user = .*|user = www|' /etc/php83/php-fpm.d/www.conf
RUN sed -i 's|group = .*|group = www|' /etc/php83/php-fpm.d/www.conf

RUN sed -i 's|memory_limit = .*|memory_limit = 512M|' /etc/php83/php.ini

# Copy entrypoint script
COPY ./entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN adduser -D -H -s /sbin/nologin -g www www

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
