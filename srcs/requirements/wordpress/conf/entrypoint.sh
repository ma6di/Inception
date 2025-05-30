#!/bin/bash
set -e  # ❗ Exit immediately on any error

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_SECONDARY_PASS=$(cat /run/secrets/wp_secondary_password)


### 🛠️ Wait until MariaDB is fully reachable (ping + TCP port)
#Runs the mysqladmin utility to check if the MySQL/MariaDB server is alive.
#ping command here sends a ping request to MariaDB server.
#-h mariadb: connects to host named mariadb (usually a Docker service or hostname).
#-u "$DB_USER": connects with username stored in environment variable DB_USER.
#-p"$DB_PASSWORD": uses password stored in environment variable DB_PASSWORD.
#--silent: suppresses output unless there is an error.
#This returns success if MariaDB is accepting connections and responding.
#Logical AND operator: the next command is only executed if the previous command succeeds.
#So the next test is only run if mysqladmin ping succeeds.
#nc = netcat, a command-line utility for reading/writing network connections.
#-z = zero-I/O mode (just check if port is open, no data sent).
#mariadb = host to check.
#3306 = TCP port number, default for MySQL/MariaDB.
#Returns success if port 3306 on mariadb is open and reachable.
until mysqladmin ping -h mariadb -u "$DB_USER" -p"$DB_PASSWORD" --silent && nc -z mariadb 3306; do
  echo "⏳ Waiting for MariaDB to be ready..."
  sleep 2
done

### 📄 Generate wp-config.php (if not already generated)
#wp-config.php is a core configuration file in WordPress. 
#It lives in the root directory of your WordPress installation
#It tells WordPress how to connect to the database (where all your website data lives).
#It contains important configuration settings that control WordPress behavior.
#Acts as the main bridge between your WordPress files and your database
if [ ! -f wp-config.php ]; then
  echo "📄 Creating wp-config.php..."
  cp wp-config-sample.php wp-config.php

  # 🔐 Fill in DB credentials and host
  sed -i "s/database_name_here/$DB_NAME/" wp-config.php
  sed -i "s/username_here/$DB_USER/" wp-config.php
  sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
  sed -i "s/localhost/mariadb/" wp-config.php

  # 🌍 Add dynamic URL settings
  #They add two PHP constants to your wp-config.php file:
  #WP_HOME — defines the home URL of your WordPress site (the public URL visitors type in to reach your site).
  #WP_SITEURL — defines the WordPress installation URL, i.e., where WordPress core files are located.
  #By setting these constants, you explicitly tell WordPress:
  #"My site is hosted at https://your-domain.com" (assuming ${DOMAIN} holds your domain name).
  #WordPress will generate URLs for pages, assets, links, admin, etc., based on this domain.
  #WordPress uses HTTPS here because of https:// prefix, which ensures links use secure protocol.
  #Overrides the URLs stored in the WordPress database, which might be outdated or wrong 
  #(especially if you move your site or use Docker containers where URLs might change).  
  echo "define('WP_HOME', 'https://${DOMAIN}');" >> wp-config.php
  echo "define('WP_SITEURL', 'https://${DOMAIN}');" >> wp-config.php
fi

### ⏳ Final check for MySQL port (extra reliability)
until nc -z mariadb 3306; do
  echo "⏳ Waiting again for MariaDB port 3306..."
  sleep 2
done

### 🚀 Install WordPress (only if not already installed)
if ! wp core is-installed --allow-root; then
  echo "🚀 Installing WordPress..."
  wp core install \
    --url="https://${DOMAIN}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root

  ### ⚠️ Secondary user creation
  # Comment out the block below if you're handling user creation via SQL
  echo "👤 Creating secondary user via wp-cli..."
  wp user create \
    "${WP_SECONDARY}" "${WP_SECONDARY_EMAIL}" \
    --user_pass="${WP_SECONDARY_PASS}" \
    --role=editor \
    --allow-root
else
  echo "✅ WordPress is already installed"
fi

mkdir -p /run/php
# Create the directory /run/php if it does not exist.
# The -p flag ensures that no error is thrown if the directory already exists.

chown www-data:www-data /run/php
# Change the ownership of the /run/php directory to the user 'www-data' and group 'www-data'.
# 'www-data' is typically the user that the web server (e.g., nginx or Apache) and PHP-FPM run under.
# This allows PHP-FPM and web server processes to have the necessary permissions to write to this directory.

exec php-fpm7.4 -F
# Replace the current shell process with the PHP-FPM process version 7.4.
# The -F option runs PHP-FPM in the foreground (no daemonizing).
# Running in foreground is essential for container environments (like Docker),
# so that the container stays alive as long as PHP-FPM is running.
