#!/bin/bash

# Wait for MariaDB
until mysqladmin ping -h mariadb -u $DB_USER -p$DB_PASSWORD --silent; do
  echo "Waiting for MariaDB..."
  sleep 2
done

# Configure WordPress
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
sed -i "s/localhost/mariadb/" wp-config.php

# ✅ Fix: ensure PHP-FPM socket directory exists
mkdir -p /run/php

# ✅ Inject extra user only if wp_users exists
if mysql -h mariadb -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "SHOW TABLES LIKE 'wp_users';" | grep wp_users; then
  echo "👤 Inserting second WordPress user..."
  mysql -h mariadb -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < /init.sql
fi


# Run PHP-FPM in foreground
exec php-fpm7.4 -F --fpm-config /etc/php/7.4/fpm/php-fpm.conf

