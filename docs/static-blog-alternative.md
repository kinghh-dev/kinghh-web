# Static Blog Deployment

Use this route if you want the fastest pages and do not need a browser-based writing backend. This repository already includes a directly deployable static blog in `site/`.

## Direct Deployment

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

Then request HTTPS:

```bash
sudo certbot --nginx -d example.com -d www.example.com
```

The deployed site root is:

```text
/var/www/kinghh-blog
```

The included pages are:

- `site/index.html`
- `site/about.html`
- `site/posts/hello-world.html`
- `site/styles.css`

To publish another article, copy `site/posts/hello-world.html`, change the title/content, and add a link to it from `site/index.html`.

## Static Generators Later

After you have more posts, you can migrate this static site to a generator.

Recommended options:

- Hugo: best for a pure blog and very fast builds.
- Astro: better if you want a modern frontend and custom pages later.

## How Writing Works

Posts are usually Markdown files committed to the project.

Example Hugo post:

```markdown
---
title: "First Post"
date: 2026-06-23
draft: false
---

This is my first blog post.
```

## Hugo Flow

Create a post:

```bash
hugo new posts/first-post.md
```

Build:

```bash
hugo
```

Generated files are placed in:

```text
public/
```

Deploy `public/` to:

```text
/var/www/blog
```

## Astro Flow

Install dependencies:

```bash
npm install
```

Build:

```bash
npm run build
```

Generated files are placed in:

```text
dist/
```

Deploy `dist/` to:

```text
/var/www/blog
```

## Minimal Static Nginx Config

```nginx
server {
    listen 80;
    server_name example.com www.example.com;

    root /var/www/blog;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

HTTPS is still handled by Certbot:

```bash
sudo certbot --nginx -d example.com -d www.example.com
```

## Compared With WordPress

Static blog advantages:

- Fastest response time.
- No database.
- Smaller attack surface.
- Low VPS resource usage.
- Easy file-based backup.

Static blog tradeoffs:

- No built-in admin backend.
- Writing usually happens in Markdown.
- Publishing requires build and deploy steps.
- Comments, search, and image management need extra work.

Use WordPress if you want the fastest writing workflow. Use Hugo or Astro if you want the lightest site.
