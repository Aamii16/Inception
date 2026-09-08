#!/bin/bash

if [ -f /var/www/html/wordpress/wp-config.php ]
then
	echo "wp already exist"
else
	MYSQL_PASSWORD=$(cat /run//secrets/db_password)
	# only wait for mariadb if wp hasn't been configured yet
	until mysqladmin ping -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    		sleep 2
	done
	cp wordpress/wp-config-sample.php wordpress/wp-config.php


	sed -i "s/username_here/$MYSQL_USER/" wordpress/wp-config.php
	sed -i "s/database_name_here/$MYSQL_DATABASE/" wordpress/wp-config.php
	sed -i "s/password_here/$MYSQL_PASSWORD/" wordpress/wp-config.php
	sed -i "s/localhost/mariadb/" wordpress/wp-config.php
	sed -i "s|define( 'ABSPATH', .* );|define( 'ABSPATH', 'wordpress/' );|" wordpress/wp-config.php

	mv wordpress /var/www/html/
	chown -R www-data:www-data /var/www/html/wordpress	
fi


WP_PATH="/var/www/html/wordpress"
if ! wp core is-installed \
	--path="$WP_PATH" \
    --allow-root >/dev/null 2>&1
then
    echo "Installing WordPress..."

    wp core install \
        --path="$WP_PATH" \
        --url="https://$DOMAIN_NAME" \
        --title="WordPress" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

	echo "Creating second user..."

	wp user create "$WP_USER" "$WP_USER_EMAIL" \
	    --user_pass="$WP_PASSWORD" \
	    --path="$WP_PATH" \
	    --allow-root
else
    echo "WordPress is already installed"
fi

exec php-fpm8.2 -F
