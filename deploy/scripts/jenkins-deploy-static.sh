#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-build}"
HUGO_VERSION="${HUGO_VERSION:-0.161.1}"
SITE_ROOT="${SITE_ROOT:-/var/www/kinghh-blog}"
SOURCE_DIR="${SOURCE_DIR:-public}"
TOOLS_DIR="${WORKSPACE:-$(pwd)}/.tools"
HUGO_BIN="${TOOLS_DIR}/hugo"

install_hugo() {
  if command -v hugo >/dev/null 2>&1; then
    current="$(hugo version | sed -n 's/.*v\([0-9.]*\).*/\1/p' | head -n 1)"
    if [ "$current" = "$HUGO_VERSION" ]; then
      HUGO_BIN="$(command -v hugo)"
      return
    fi
  fi

  if [ -x "$HUGO_BIN" ]; then
    return
  fi

  mkdir -p "$TOOLS_DIR"
  archive="${TOOLS_DIR}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
  url="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"

  curl -fsSL "$url" -o "$archive"
  tar -xzf "$archive" -C "$TOOLS_DIR" hugo
  chmod +x "$HUGO_BIN"
}

build_site() {
  install_hugo
  rm -rf "$SOURCE_DIR"
  "$HUGO_BIN" --gc --minify
}

deploy_site() {
  if [ ! -d "$SOURCE_DIR" ]; then
    echo "Build output not found: ${SOURCE_DIR}"
    exit 1
  fi

  sudo mkdir -p "$SITE_ROOT"
  sudo rsync -a --delete "${SOURCE_DIR}/" "${SITE_ROOT}/"
  sudo chown -R www-data:www-data "$SITE_ROOT"
  sudo find "$SITE_ROOT" -type d -exec chmod 755 {} \;
  sudo find "$SITE_ROOT" -type f -exec chmod 644 {} \;

  if command -v nginx >/dev/null 2>&1; then
    sudo nginx -t
    sudo systemctl reload nginx
  fi
}

case "$ACTION" in
  build)
    build_site
    ;;
  deploy)
    deploy_site
    ;;
  all)
    build_site
    deploy_site
    ;;
  *)
    echo "Usage: $0 [build|deploy|all]"
    exit 2
    ;;
esac
