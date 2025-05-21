# ~/inception/srcs/requirements/nginx/Dockerfile

FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/ssl/server.crt /etc/ssl/certs/server.crt
COPY ./conf/ssl/server.key /etc/ssl/private/server.key

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
