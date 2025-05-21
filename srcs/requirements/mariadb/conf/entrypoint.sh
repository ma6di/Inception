#!/bin/bash

# Start MariaDB in background
mysqld_safe --datadir=/var/lib/mysql &

# # Wait until MariaDB is ready
# until mysqladmin ping --silent; do
#   echo "⏳ Waiting for MariaDB to be ready..."
#   sleep 2
# done

until mysqladmin ping -h mariadb -u $DB_USER -p$DB_PASSWORD --silent; do
  echo "⏳ Still waiting for MariaDB @ mariadb with $DB_USER/$DB_PASSWORD..."
  sleep 2
done

# Setup database and user
mysql -u root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -u root -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
mysql -u root -e "FLUSH PRIVILEGES;"
mysql -u root < /init.sql

# Keep the DB running
wait
