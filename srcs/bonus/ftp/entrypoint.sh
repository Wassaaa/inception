#!/bin/sh
set -euo pipefail

FTP_PASS="$(cat /run/secrets/ftp_pass)"

# ---------- 0. defaults ----------
: "${MIN_PORT:=21000}"
: "${MAX_PORT:=21010}"
: "${WP_PATH:=/var/www/html}"
: "${FTP_USER:=ftpuser}"

echo "pasv_min_port=21000" >> /etc/vsftpd.conf
echo "pasv_max_port=21010" >> /etc/vsftpd.conf

adduser -D -G www-data -h ${WP_PATH} -s /sbin/nologin ${FTP_USER}
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

exec "$@"
