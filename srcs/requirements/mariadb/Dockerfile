FROM alpine:3.20.6
RUN apk add --no-cache mariadb mariadb-client tini

# Create necessary directories
RUN mkdir -p /run/mysqld /docker-entrypoint-initdb.d \
 && chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy configuration
COPY conf/my.cnf /etc/my.cnf

# Copy initialization script
COPY tools/init-db.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

EXPOSE 3306

# Use an entrypoint script to initialize DB and start MariaDB
COPY entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod +x /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["/sbin/tini","--","docker-entrypoint.sh"]
CMD ["mariadbd","--console"]
