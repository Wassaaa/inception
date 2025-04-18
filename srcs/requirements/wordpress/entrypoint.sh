#!/bin/sh

: "${WP_PATH:=/var/www/html}"
export WP_PATH
mkdir -p "${WP_PATH}"
cd "${WP_PATH}"

while ! mariadb-admin -h mariadb -u "$MYSQL_USER" -p"$MYSQL_PASS" ping --silent; do
    echo "Waiting for MariaDB database..."
    sleep 1
done


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
		--allow-root \
		--skip-email

    echo "Creating user..."
    wp user create "${WP_USER}" "${WP_MAIL}" \
		--role=author \
      	--user_pass="${WP_PASS}" \
		--allow-root
else
    echo "WordPress is already setup."
fi

echo "Setting permissions and owners..."
chown -R www:www ${WP_PATH}
chmod -R 775 ${WP_PATH}

echo ">> Starting PHP-FPM ($*)"
exec "$@"
