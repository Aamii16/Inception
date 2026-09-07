#!/bin/bash

service mariadb start

#uncomment this when you finish whole rpoject setup and compose

DB_PASSWORD="$(cat /run/secrets/db_password)"
DB_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"


mysql -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;"

mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"

mysql -e "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';"

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';"

mysql -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p$DB_ROOT_PASSWORD shutdown

exec mysqld
