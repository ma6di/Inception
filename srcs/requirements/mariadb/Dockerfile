# ~/inception/srcs/requirements/mariadb/Dockerfile

FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean

RUN sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./conf/entrypoint.sh /entrypoint.sh
COPY ./conf/init.sql /init.sql

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
