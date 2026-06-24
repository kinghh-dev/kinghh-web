# KingHH Blog

Minimal personal blog files and deployment scripts for a VPS-hosted site.

There are two usable routes in this repository.

## Route A: Static Blog, Directly Deployable

Use this if you want a page that can go online immediately without MySQL, PHP, or WordPress.

Local site files:

- [site/index.html](site/index.html)
- [site/about.html](site/about.html)
- [site/posts/hello-world.html](site/posts/hello-world.html)
- [site/styles.css](site/styles.css)

Deploy files:

- [deploy/scripts/deploy-static-ubuntu.sh](deploy/scripts/deploy-static-ubuntu.sh)
- [deploy/nginx/static-blog.conf](deploy/nginx/static-blog.conf)

Upload this project to the VPS:

```bash
scp -r . root@1.2.3.4:/root/kinghh-web
```

Run on the VPS:

```bash
cd /root/kinghh-web
export BLOG_DOMAIN="example.com"
export BLOG_WWW_DOMAIN="www.example.com"
sudo -E bash deploy/scripts/deploy-static-ubuntu.sh
```

Then enable HTTPS:

```bash
sudo certbot --nginx -d example.com -d www.example.com
```

## Route B: WordPress Blog

Use this if you want a browser admin backend at `/wp-admin`.

Recommended WordPress stack:

- Ubuntu 22.04 or 24.04
- Nginx
- WordPress
- PHP-FPM
- MySQL
- Let's Encrypt HTTPS

WordPress files:

- [WordPress deployment guide](docs/wordpress-deploy.md)
- [deploy/nginx/wordpress.conf](deploy/nginx/wordpress.conf)
- [deploy/scripts/install-wordpress-ubuntu.sh](deploy/scripts/install-wordpress-ubuntu.sh)

The local repository does not contain WordPress source code. WordPress is downloaded on the VPS during deployment, and the important long-term assets are the database plus `/var/www/blog/wp-content`.

## Recommendation

For the fastest visible result, deploy Route A first. When you decide you need a backend editor, deploy Route B on the same VPS or migrate the content into WordPress.
