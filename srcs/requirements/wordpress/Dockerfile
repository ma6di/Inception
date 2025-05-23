# Use a minimal Debian base image for smaller size and security
FROM debian:bullseye-slim

# Update package lists and install PHP, PHP-FPM, MySQL client, wget, unzip, curl, and other dependencies
# 'default-mysql-client' is needed to interact with the MySQL database from the container
RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql wget unzip curl default-mysql-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create the directory where WordPress files will live, ensure it exists
RUN mkdir -p /var/www/html

# Configure PHP-FPM to listen on all network interfaces on port 9000
# This allows the web server (e.g., Nginx) to communicate with PHP-FPM via TCP socket
RUN sed -i 's|listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Download the latest WordPress package from the official source,
# extract it, remove the archive to save space,
# move WordPress files to /var/www/html, which is the web root,
# and set ownership to www-data (the default PHP-FPM user) for correct permissions
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz && \
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
