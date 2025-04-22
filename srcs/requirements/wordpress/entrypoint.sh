#!/bin/sh
set -euo pipefail

# default WordPress path setup
: "${WP_PATH:=/var/www/html}"
export WP_PATH
mkdir -p "${WP_PATH}"
cd "${WP_PATH}"

# wait for mariadb
while ! mariadb-admin -h mariadb -u "$MYSQL_USER" -p"$MYSQL_PASS" ping --silent; do
    echo "Waiting for MariaDB database..."
    sleep 1
done

# download and configure WordPress
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating configuration..."
    wp core config \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASS} \
		--dbhost=${MYSQL_HOST} \
		--allow-root

    echo "Installing WordPress..."
    wp core install \
		--url=${SERVER_NAME} \
		--title=${WP_TITLE} \
		--admin_user=${WP_ADMIN} \
		--admin_password=${WP_ADMIN_PASS} \
		--admin_email=${WP_ADMIN_MAIL} \
		--allow-root

    echo "Creating user..."
	if ! wp user get "${WP_USER}" --field=ID --allow-root > /dev/null 2>&1; then
        wp user create \
		"${WP_USER}" \
		"${WP_MAIL}" \
		--role=author \
		--user_pass="${WP_PASS}" \
		--allow-root

	echo "installing theme..."
		wp theme install neve --allow-root
		wp theme activate neve --allow-root
		wp theme update neve --allow-root

    else
        echo "User ${WP_USER} already exists, skipping creation."
    fi
else
    echo "WordPress is already setup."
fi

echo "Installing and activating plugins..."
	wp plugin install redis-cache --allow-root
	wp plugin activate redis-cache --allow-root
	wp config set WP_REDIS_HOST "redis" --allow-root
	wp config set WP_REDIS_PORT 6379 --allow-root
	wp redis enable --allow-root

echo "Setting permissions and owners..."
chown -R www-data:www-data ${WP_PATH}
chmod -R 775 ${WP_PATH}
chmod g+s ${WP_PATH}

echo ">> Starting PHP-FPM ($*)"
exec "$@"
