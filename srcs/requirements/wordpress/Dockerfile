# Use a minimal Debian base image for smaller size and security
FROM debian:bullseye-slim

# 🛠️ Update the package list and install necessary PHP components and tools
RUN apt-get update && \
    # Core PHP interpreter
    apt-get install -y php && \
    # PHP FastCGI Process Manager (required to serve WordPress via NGINX)
    apt-get install -y php-fpm && \
    # PHP MySQL driver so WordPress can talk to MariaDB
    apt-get install -y php-mysql && \
    # cURL for downloading files like WP-CLI or WordPress
    apt-get install -y curl && \
    # Netcat used in startup scripts to wait for DB availability
    apt-get install -y netcat && \
    # MySQL client for debugging DB connections (optional)
    apt-get install -y default-mysql-client && \
    # Clean up APT cache to reduce final image size
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    # Configure PHP-FPM to listen on TCP port 9000 instead of default Unix socket
    sed -i 's|listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

    # Create the directory where WordPress files will live, ensure it exists
RUN mkdir -p /var/www/html

# 📥 Download the official WP-CLI Phar (PHP Archive) from GitHub
# ✅ WP-CLI is the command-line tool to manage WordPress (install, configure, manage users, etc.)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    # 🔐 Make the file executable so it can be run directly from the shell
    chmod +x wp-cli.phar && \
    # 🚀 Move the executable to a directory in the system PATH so it can be used like any command (e.g., `wp`)
    mv wp-cli.phar /usr/local/bin/wp

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Download the WordPress 6.5.3 version package from the official source,
# extract it, remove the archive to save space,
# move WordPress files to /var/www/html, which is the web root,
# and set ownership to www-data (the default PHP-FPM user) for correct permissions
ENV WP_VERSION=6.5.3

RUN curl -O https://wordpress.org/wordpress-${WP_VERSION}.tar.gz && \
    tar -xzf wordpress-${WP_VERSION}.tar.gz && \
    rm wordpress-${WP_VERSION}.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    chown -R www-data:www-data /var/www/html

# Copy the initial SQL setup file to the container root for later initialization of the database schema and data
COPY ./conf/init.sql /init.sql

# Copy the entrypoint script that will run when the container starts
# This script typically initializes the database, starts PHP-FPM, or performs other startup tasks
COPY ./conf/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the working directory for commands that follow (like running scripts or php-fpm)
WORKDIR /var/www/html

# Expose port 9000 so other services (like Nginx) in Docker can connect to PHP-FPM
EXPOSE 9000

# Use the custom entrypoint script to control container startup behavior
ENTRYPOINT ["/entrypoint.sh"]
