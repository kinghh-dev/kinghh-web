#!/usr/bin/env bash
set -euo pipefail

: "${BLOG_DOMAIN:?Set BLOG_DOMAIN, for example example.com}"
: "${WP_DB_NAME:=wordpress}"
: "${WP_DB_USER:=wpuser}"
: "${WP_DB_PASSWORD:?Set WP_DB_PASSWORD to a strong password}"

SITE_ROOT="${SITE_ROOT:-/var/www/blog}"
BLOG_WWW_DOMAIN="${BLOG_WWW_DOMAIN:-}"
SERVER_NAMES="$BLOG_DOMAIN"

if [ -n "$BLOG_WWW_DOMAIN" ]; then
  SERVER_NAMES="$SERVER_NAMES $BLOG_WWW_DOMAIN"
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this script as root or with sudo."
  exit 1
fi

apt update
apt upgrade -y
apt install -y nginx mysql-server php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip unzip curl rsync certbot python3-certbot-nginx

if command -v ufw >/dev/null 2>&1; then
  ufw allow 'Nginx Full' || true
fi

mysql <<SQL
CREATE DATABASE IF NOT EXISTS \`${WP_DB_NAME}\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'localhost' IDENTIFIED BY '${WP_DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WP_DB_NAME}\`.* TO '${WP_DB_USER}'@'localhost';
FLUSH PRIVILEGES;
SQL

mkdir -p /var/www
tmp_dir="$(mktemp -d)"
curl -L https://wordpress.org/latest.zip -o "$tmp_dir/latest.zip"
unzip -q "$tmp_dir/latest.zip" -d "$tmp_dir"

if [ ! -d "$SITE_ROOT" ]; then
  mv "$tmp_dir/wordpress" "$SITE_ROOT"
else
  rsync -a "$tmp_dir/wordpress/" "$SITE_ROOT/"
fi

rm -rf "$tmp_dir"
chown -R www-data:www-data "$SITE_ROOT"
find "$SITE_ROOT" -type d -exec chmod 755 {} \;
find "$SITE_ROOT" -type f -exec chmod 644 {} \;

php_socket="$(find /run/php -maxdepth 1 -name 'php*-fpm.sock' | sort -V | tail -n 1)"

if [ -z "$php_socket" ]; then
  echo "No PHP-FPM socket found in /run/php."
  exit 1
fi

cat > /etc/nginx/sites-available/blog <<NGINX
server {
    listen 80;
    server_name ${SERVER_NAMES};

    root ${SITE_ROOT};
    index index.php index.html index.htm;

    access_log /var/log/nginx/blog.access.log;
    error_log /var/log/nginx/blog.error.log;

    client_max_body_size 32m;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:${php_socket};
    }

    location ~* \.(css|gif|ico|jpeg|jpg|js|png|svg|webp|woff|woff2)$ {
        expires 30d;
        access_log off;
        try_files \$uri =404;
    }

    location ~ /\.ht {
        deny all;
    }
}
NGINX

ln -sfn /etc/nginx/sites-available/blog /etc/nginx/sites-enabled/blog
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl reload nginx

echo "WordPress files are ready at ${SITE_ROOT}."
echo "Open http://${BLOG_DOMAIN} to finish WordPress setup."
echo "After DNS is ready, run:"
if [ -n "$BLOG_WWW_DOMAIN" ]; then
  echo "certbot --nginx -d ${BLOG_DOMAIN} -d ${BLOG_WWW_DOMAIN}"
else
  echo "certbot --nginx -d ${BLOG_DOMAIN}"
fi
