#!/usr/bin/env bash
set -euo pipefail

BLOG_HOME="${BLOG_HOME:-/opt/blog}"
FRONTEND_DIST="blog-frontend/dist"
BACKEND_JAR="blog-backend/target/blog-api.jar"

if [ ! -d "$FRONTEND_DIST" ]; then
  echo "Frontend dist not found: $FRONTEND_DIST" >&2
  exit 1
fi

if [ ! -f "$BACKEND_JAR" ]; then
  echo "Backend jar not found: $BACKEND_JAR" >&2
  exit 1
fi

sudo mkdir -p "$BLOG_HOME/frontend/dist" "$BLOG_HOME/backend" "$BLOG_HOME/logs" "$BLOG_HOME/scripts" "$BLOG_HOME/backup"
sudo rsync -a --delete "$FRONTEND_DIST/" "$BLOG_HOME/frontend/dist/"
sudo install -m 0644 "$BACKEND_JAR" "$BLOG_HOME/backend/blog-api.jar"
sudo install -m 0755 deploy/blog/scripts/restart.sh "$BLOG_HOME/scripts/restart.sh"

sudo chown -R www-data:www-data "$BLOG_HOME/frontend"
sudo chown -R root:root "$BLOG_HOME/backend" "$BLOG_HOME/scripts"
sudo chmod 755 "$BLOG_HOME" "$BLOG_HOME/frontend" "$BLOG_HOME/frontend/dist" "$BLOG_HOME/backend" "$BLOG_HOME/scripts"

sudo "$BLOG_HOME/scripts/restart.sh"

if command -v nginx >/dev/null 2>&1; then
  sudo nginx -t
  sudo systemctl reload nginx
fi
