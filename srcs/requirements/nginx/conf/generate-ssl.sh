#!/bin/bash

set -e

SSL_DIR="/etc/nginx/ssl"
mkdir -p "$SSL_DIR"

# Generate new self-signed certificate
openssl req -x509 -nodes -days 365 \
  -subj "/C=FR/ST=Paris/L=Paris/O=42" \
  -newkey rsa:2048 \
  -keyout "$SSL_DIR/server.key" \
  -out "$SSL_DIR/server.crt"

exec "$@"