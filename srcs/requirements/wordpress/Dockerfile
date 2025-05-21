FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql wget unzip curl && \
    apt-get clean

# ✅ Create the target directory before moving
RUN mkdir -p /var/www/html

RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql wget unzip curl default-mysql-client && \
    apt-get clean

RUN sed -i 's|listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Install WordPress
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    chown -R www-data:www-data /var/www/html
    
COPY ./conf/init.sql /init.sql
COPY ./conf/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
