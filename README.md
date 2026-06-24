# KingHH Blog

Personal blog built with Hugo and the Blowfish theme, deployed as a static site on a VPS through Nginx.

Current stack:

- Hugo Extended `0.161.1`
- Blowfish theme `v2.103.0`
- Markdown content under `content/`
- Static assets under `assets/`
- Nginx on Ubuntu VPS
- Let's Encrypt HTTPS

## Write

Posts live in:

```text
content/posts/
```

Create a new post by adding a Markdown file:

```text
content/posts/my-new-post.md
```

Example front matter:

```markdown
---
title: "文章标题"
date: 2026-06-24
description: "文章摘要。"
tags: ["hugo", "blogging"]
categories: ["技术栈"]
---
```

## Build

Use Hugo Extended `0.161.1`:

```bash
hugo --gc --minify
```

The generated site is written to:

```text
public/
```

`public/` is ignored by Git because it is a build artifact.

## Deploy

The VPS serves:

```text
/var/www/kinghh-blog
```

The deploy script syncs `public/` to that directory:

```bash
export BLOG_DOMAIN="kinghh.cn"
export BLOG_WWW_DOMAIN="www.kinghh.cn"
sudo -E bash deploy/scripts/deploy-static-ubuntu.sh
```

Nginx and HTTPS config:

- [deploy/nginx/static-blog.conf](deploy/nginx/static-blog.conf)
- [deploy/scripts/deploy-static-ubuntu.sh](deploy/scripts/deploy-static-ubuntu.sh)
- [docs/jenkins-deploy.md](docs/jenkins-deploy.md)

## Existing Content

- [content/_index.md](content/_index.md)
- [content/about.md](content/about.md)
- [content/posts/hello-world.md](content/posts/hello-world.md)
- [content/posts/tech-stack.md](content/posts/tech-stack.md)

## WordPress Backup Plan

If a browser-based writing backend is needed later, the WordPress deployment files are still available:

- [docs/wordpress-deploy.md](docs/wordpress-deploy.md)
- [deploy/nginx/wordpress.conf](deploy/nginx/wordpress.conf)
- [deploy/scripts/install-wordpress-ubuntu.sh](deploy/scripts/install-wordpress-ubuntu.sh)
