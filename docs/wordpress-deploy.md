# WordPress Deployment Guide

This is the recommended first deployment for a simple personal blog.

Replace these examples before running commands:

- `example.com`: your domain
- `www.example.com`: optional www domain
- `1.2.3.4`: your VPS public IP
- `CHANGE_ME_STRONG_PASSWORD`: a strong MySQL password

## 1. DNS

In your domain provider's DNS console, add:

```text
Type: A
Host: @
Value: 1.2.3.4
```

Optional:

```text
Type: A
Host: www
Value: 1.2.3.4
```

Wait until DNS resolves to the VPS.

```bash
nslookup example.com
nslookup www.example.com
```

## 2. Install Services

SSH into the VPS:

```bash
ssh root@1.2.3.4
```

Copy this repository or at least the `deploy/scripts` directory to the VPS. For example, from your local machine:

```bash
scp -r deploy root@1.2.3.4:/root/kinghh-web-deploy
```

Then on the VPS:

```bash
cd /root/kinghh-web-deploy
```

Run the provided install script with your own values:

```bash
export BLOG_DOMAIN="example.com"
export BLOG_WWW_DOMAIN="www.example.com"
export WP_DB_NAME="wordpress"
export WP_DB_USER="wpuser"
export WP_DB_PASSWORD="CHANGE_ME_STRONG_PASSWORD"

bash deploy/scripts/install-wordpress-ubuntu.sh
```

Use a database password without single quotes to keep the shell-based setup simple. If you copy only the script to the VPS, run it from the directory where the script exists and adjust the script path accordingly.

## 3. Manual Nginx Config

If you do not use the script, copy `deploy/nginx/wordpress.conf` to:

```text
/etc/nginx/sites-available/blog
```

Then replace:

- `example.com www.example.com`
- `/run/php/php8.3-fpm.sock` if your PHP version is different

Check your PHP-FPM socket:

```bash
ls /run/php/
```

Enable the site:

```bash
sudo ln -s /etc/nginx/sites-available/blog /etc/nginx/sites-enabled/blog
sudo nginx -t
sudo systemctl reload nginx
```

## 4. HTTPS

After DNS points to the VPS and Nginx is working:

```bash
sudo certbot --nginx -d example.com -d www.example.com
```

Choose HTTP to HTTPS redirection when prompted.

Test renewal:

```bash
sudo certbot renew --dry-run
```

## 5. WordPress Initialization

Open:

```text
https://example.com
```

Use these database values:

```text
Database name: wordpress
Database user: wpuser
Database password: CHANGE_ME_STRONG_PASSWORD
Database host: localhost
Table prefix: wp_
```

Admin URL:

```text
https://example.com/wp-admin
```

## 6. First Settings

Recommended first changes:

- Set permalinks to post name.
- Delete default posts and pages.
- Choose a simple theme.
- Install only necessary plugins.
- Back up MySQL and `/var/www/blog/wp-content`.

Suggested plugin categories:

- Cache
- SEO
- Backup
- Anti-spam if comments are enabled

## 7. Backup Targets

The important data is:

```text
/var/www/blog/wp-content
MySQL database: wordpress
```

Example database export:

```bash
mysqldump -u wpuser -p wordpress > wordpress-backup.sql
```
