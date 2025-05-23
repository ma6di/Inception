#!/bin/bash
set -e

# Wait for MariaDB to be ready to accept connections
until mysqladmin ping -h mariadb -u "$DB_USER" -p"$DB_PASSWORD" --silent; do
  echo "Waiting for MariaDB..."
  sleep 2
done

echo "MariaDB is up, configuring WordPress..."

# Copy the sample wp-config to wp-config.php to configure WordPress DB connection
cp wp-config-sample.php wp-config.php

# Replace placeholders with actual DB credentials and hostname
sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
sed -i "s/localhost/mariadb/" wp-config.php

# Ensure PHP-FPM socket directory exists to avoid runtime errors
mkdir -p /run/php

# Check if the wp_users table exists before trying to insert additional users
if mysql -h mariadb -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "SHOW TABLES LIKE 'wp_users';" | grep -q wp_users; then
  echo "👤 WordPress users table found, injecting extra user from /init.sql..."
  mysql -h mariadb -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < /init.sql
else
  echo "⚠️ wp_users table not found, skipping user injection"
fi

# Start PHP-FPM in the foreground to keep container running
exec php-fpm7.4 -F --fpm-config /etc/php/7.4/fpm/php-fpm.conf
