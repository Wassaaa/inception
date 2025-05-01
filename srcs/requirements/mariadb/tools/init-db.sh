#!/bin/sh

MYSQL_ROOT_PASS="$(cat /run/secrets/mysql_root_pass)"
MYSQL_PASS="$(cat /run/secrets/mysql_pass)"

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo ">> Initialising MariaDB data directory"
    mariadb-install-db --user=mysql --skip-name-resolve >/dev/null

    echo ">> Bootstrapping privileges and database"
    mariadbd --user=mysql --bootstrap <<-EOF
      FLUSH PRIVILEGES;
      ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';
      CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASS}';
      GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

      CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
      CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASS}';
      GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
      FLUSH PRIVILEGES;
EOF
fi
