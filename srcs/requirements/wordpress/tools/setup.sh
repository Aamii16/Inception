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

exec php-fpm8.2 -F
