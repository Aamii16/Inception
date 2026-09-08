#!/bin/bash

mkdir -p /var/run/mysqld /var/lib/mysql
chown 755 /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    rm -rf /var/lib/mysql/.init
    echo "System tables missing. Initializing MariaDB system databases..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

if [ ! -f "/var/lib/mysql/.init" ]; then
    echo "db doesn't exist"
    echo "Intialiasing database..."
    service mariadb start
    sleep 1 

    DB_PASSWORD="$(cat /run/secrets/db_password)"
    DB_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"

    echo "Creating database..."
    mysql -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;"
    echo "Creating User..."

    mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
    echo "Granting Privileges..."
    mysql -e "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';"
    echo "Flushing Privileges..."

    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';"

    mysql -e "FLUSH PRIVILEGES;"

    touch /var/lib/mysql/.init

    service mariadb stop
    sleep 1
fi
exec mysqld
