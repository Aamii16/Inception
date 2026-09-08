#!/bin/bash

mkdir -p /var/run/mysqld /var/lib/mysql
chown 755 /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "System tables missing. Initializing MariaDB system databases..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

if [ ! -f "/var/lib/mysql/.init" ]; then

    service mariadb start
    sleep 1 

    DB_PASSWORD="$(cat /run/secrets/db_password)"
    DB_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"


    mysql -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;"

    mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"

    mysql -e "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';"

    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';"

    mysql -e "FLUSH PRIVILEGES;"

    touch /var/lib/mysql/.init

    service mariadb stop
    sleep 1
fi
exec mysqld
