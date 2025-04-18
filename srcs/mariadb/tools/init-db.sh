#!/bin/sh

if [ -d "/var/lib/mysql/mysql" ]; then
    echo "Database already initialized, skipping initialization"
    exit 0
fi

mariadb-install-db

# Start MariaDB server for initialization
echo "Setting up users"
/usr/bin/mariadbd --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

-- Change root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Create root user for any host
CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Create database and user if specified
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF
