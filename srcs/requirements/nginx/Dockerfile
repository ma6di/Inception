# 🏗️ Use Debian slim base image (lightweight and supported by Inception rules)
# ✅ Subject requires building from Alpine or Debian — this is compliant
FROM debian:bullseye-slim

# 🛠️ Install NGINX and OpenSSL for HTTPS support
# ✅ Required: NGINX must serve WordPress over HTTPS only (port 443)
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean

# 📥 Copy your custom NGINX config into the container
# ✅ Needed to define HTTPS server, TLS protocols, and reverse proxy to WordPress
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/generate-ssl.sh /generate-ssl.sh

RUN chmod +x /generate-ssl.sh

# 🌐 Expose port 443 for secure HTTPS traffic
# ✅ This is the **only** public-facing port allowed in the project
EXPOSE 443

RUN ./generate-ssl.sh
# 🚀 Run NGINX in the foreground
# ✅ Required: keeps container alive, and ensures it acts as the only entry point
CMD ["nginx", "-g", "daemon off;"]
