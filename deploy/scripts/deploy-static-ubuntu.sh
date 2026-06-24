#!/usr/bin/env bash
set -euo pipefail

: "${BLOG_DOMAIN:?Set BLOG_DOMAIN, for example example.com}"

SITE_ROOT="${SITE_ROOT:-/var/www/kinghh-blog}"
BLOG_WWW_DOMAIN="${BLOG_WWW_DOMAIN:-}"
SOURCE_DIR="${SOURCE_DIR:-site}"
SERVER_NAMES="$BLOG_DOMAIN"

if [ -n "$BLOG_WWW_DOMAIN" ]; then
  SERVER_NAMES="$SERVER_NAMES $BLOG_WWW_DOMAIN"
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this script as root or with sudo."
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Source directory not found: $SOURCE_DIR"
  echo "Run this script from the project root, or set SOURCE_DIR."
  exit 1
fi

apt update
apt install -y nginx rsync certbot python3-certbot-nginx

if command -v ufw >/dev/null 2>&1; then
  ufw allow 'Nginx Full' || true
fi

mkdir -p "$SITE_ROOT"
rsync -a --delete "$SOURCE_DIR"/ "$SITE_ROOT"/
chown -R www-data:www-data "$SITE_ROOT"
find "$SITE_ROOT" -type d -exec chmod 755 {} \;
find "$SITE_ROOT" -type f -exec chmod 644 {} \;

cat > /etc/nginx/sites-available/kinghh-blog <<NGINX
server {
    listen 80;
    server_name ${SERVER_NAMES};

    root ${SITE_ROOT};
    index index.html;

    access_log /var/log/nginx/kinghh-blog.access.log;
    error_log /var/log/nginx/kinghh-blog.error.log;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~* \.(css|gif|ico|jpeg|jpg|js|png|svg|webp|woff|woff2)$ {
        expires 30d;
        access_log off;
        try_files \$uri =404;
    }
}
NGINX

ln -sfn /etc/nginx/sites-available/kinghh-blog /etc/nginx/sites-enabled/kinghh-blog
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl reload nginx

echo "Static blog deployed to ${SITE_ROOT}."
echo "Open http://${BLOG_DOMAIN} to verify it."
echo "After DNS is ready, run:"
if [ -n "$BLOG_WWW_DOMAIN" ]; then
  echo "certbot --nginx -d ${BLOG_DOMAIN} -d ${BLOG_WWW_DOMAIN}"
else
  echo "certbot --nginx -d ${BLOG_DOMAIN}"
fi
