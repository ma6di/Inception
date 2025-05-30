# 🔧 Use Debian slim as a minimal, secure base image (✅ Inception requires Alpine or Debian-based)
FROM debian:bullseye-slim

# 🧱 Install MariaDB (a drop-in replacement for MySQL) and clean up cache to keep image size small
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean

# 🌍 Configure MariaDB to accept connections from any IP address, not just localhost
# ✅ Required to allow WordPress to connect via container hostname (`mariadb`)
# This line modifies MariaDB’s configuration file to allow incoming connections 
# from any IP address, not just from localhost
RUN sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# 📥 Copy the custom entrypoint script that will configure the DB at container startup
COPY ./conf/entrypoint.sh /entrypoint.sh

# 🔐 Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# 🚀 Use the entrypoint script to start MariaDB and configure everything
ENTRYPOINT ["/entrypoint.sh"]
