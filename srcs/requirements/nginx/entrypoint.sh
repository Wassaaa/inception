#!/bin/sh
set -euo pipefail

# ---------- 0. defaults ----------
: "${SSL_CERT_DIR:=/etc/nginx/certs}"
: "${SSL_KEY:=$SSL_CERT_DIR/server.key}"
: "${SSL_CRT:=$SSL_CERT_DIR/server.crt}"
: "${SERVER_NAME:=aklein.42.fr}"
export SERVER_NAME SSL_KEY SSL_CRT

if [ ! -f "$SSL_CRT" ] || [ ! -f "$SSL_KEY" ]; then
  echo ">> No certificate found – creating self‑signed one"
  mkdir -p "$SSL_CERT_DIR"
  openssl req -x509 -nodes -newkey rsa:4096 -days 365 \
          -subj "/C=FI/L=Helsinki/O=Hive/OU=Student/CN=$SERVER_NAME" \
		  -addext "subjectAltName=DNS:${SERVER_NAME}" \
          -keyout "$SSL_KEY" -out "$SSL_CRT" > /dev/null 2>&1
  chmod 600 "$SSL_KEY" "$SSL_CRT"
fi

envsubst '$$SERVER_NAME $SSL_CRT $SSL_KEY $WP_PATH $MYSQL_HOST $MYSQL_DATABASE' < /etc/nginx/nginx.conf > /tmp/nginx.conf
mv /tmp/nginx.conf /etc/nginx/nginx.conf

echo ">> Starting Nginx ($*)"
exec "$@"
