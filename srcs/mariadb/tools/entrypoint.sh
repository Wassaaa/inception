#!/bin/sh
set -e

# Initialize database if needed
if [ -f "/docker-entrypoint-initdb.d/init-db.sh" ]; then
    sh /docker-entrypoint-initdb.d/init-db.sh
fi

# Start MariaDB server
exec mariadbd --console
