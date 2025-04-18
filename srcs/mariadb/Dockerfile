FROM alpine:3.20.6
RUN apk update && apk add --no-cache mariadb mariadb-client

# Create necessary directories
RUN mkdir -p /run/mysqld /docker-entrypoint-initdb.d
RUN chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy configuration
COPY conf/my.cnf /etc/my.cnf

# Copy initialization script
COPY tools/init-db.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

EXPOSE 3306

# Use an entrypoint script to initialize DB and start MariaDB
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
