# Hugo Static Blog Deployment

This project now uses Hugo and the Blowfish theme.

## Structure

```text
config/_default/      Hugo and Blowfish configuration
content/              Markdown pages and posts
assets/               Source assets used by Hugo
themes/blowfish/      Vendored Blowfish theme
public/               Generated site, ignored by Git
```

## Write A Post

Create a Markdown file under `content/posts/`:

```markdown
---
title: "文章标题"
date: 2026-06-24
description: "文章摘要。"
tags: ["hugo", "blogging"]
categories: ["技术栈"]
---

正文内容。
```

## Build

Install Hugo Extended `0.161.1`, then run:

```bash
hugo --gc --minify
```

The generated files are placed in:

```text
public/
```

## Deploy

Upload the repository or the generated `public/` directory to the VPS. The deploy script expects `public/` by default:

```bash
cd /root/kinghh-web
export BLOG_DOMAIN="kinghh.cn"
export BLOG_WWW_DOMAIN="www.kinghh.cn"
sudo -E bash deploy/scripts/deploy-static-ubuntu.sh
```

The deployed site root is:

```text
/var/www/kinghh-blog
```

HTTPS is handled by Certbot:

```bash
sudo certbot --nginx -d kinghh.cn -d www.kinghh.cn
```

## Compared With WordPress

Hugo advantages:

- Fast static pages.
- No database.
- Markdown writing workflow.
- Built-in RSS, taxonomy pages, generated indexes, and search JSON.
- Lower security and maintenance burden.

Hugo tradeoffs:

- No browser-based admin backend.
- Publishing requires a build step.
- Comments require an external or self-hosted service.

Use Hugo while the site is mainly a personal writing system. Move to WordPress only if browser-based editing becomes more important than simplicity.
