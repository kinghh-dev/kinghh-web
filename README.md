# KingHH Blog

这是一个使用 Hugo 和 Blowfish 主题构建的个人博客，部署方式是：Hugo 生成静态页面，VPS 上的 Nginx 对外提供访问。

当前技术栈：

- Hugo Extended `0.161.1`
- Blowfish 主题 `v2.103.0`
- 文章内容放在 `content/`
- 静态资源放在 `assets/` 和 `static/`
- Ubuntu VPS + Nginx
- Let's Encrypt HTTPS
- Jenkins 自动构建和发布

## 写文章

文章目录：

```text
content/posts/
```

新建一篇文章时，在这个目录下新增 Markdown 文件即可：

```text
content/posts/my-new-post.md
```

文章头部示例：

```markdown
---
title: "文章标题"
date: 2026-06-24
description: "文章摘要。"
tags: ["hugo", "blogging"]
categories: ["技术栈"]
---
```

首页内容在：

```text
content/_index.md
```

关于页面在：

```text
content/about.md
```

## 本地构建

需要使用 Hugo Extended `0.161.1`：

```bash
hugo --gc --minify
```

构建结果会生成到：

```text
public/
```

`public/` 是构建产物，不需要提交到 Git。

## 自动部署

线上网站目录：

```text
/var/www/kinghh-blog
```

当前已经配置 Jenkins 自动部署。日常发布流程是：

```bash
git add .
git commit -m "更新博客内容"
git push origin master
```

Jenkins 会检测 `master` 分支的新提交，自动执行 Hugo 构建，并把 `public/` 发布到 VPS。

Jenkins 访问地址：

```text
https://kinghh.cn/jenkins/login
```

部署说明：

- [docs/jenkins-deploy.md](docs/jenkins-deploy.md)
- [deploy/nginx/static-blog.conf](deploy/nginx/static-blog.conf)
- [deploy/scripts/deploy-static-ubuntu.sh](deploy/scripts/deploy-static-ubuntu.sh)

## 手动部署

如果需要绕过 Jenkins，在 VPS 上手动发布，可以执行：

```bash
export BLOG_DOMAIN="kinghh.cn"
export BLOG_WWW_DOMAIN="www.kinghh.cn"
sudo -E bash deploy/scripts/deploy-static-ubuntu.sh
```

## 现有内容

- [content/_index.md](content/_index.md)
- [content/about.md](content/about.md)
- [content/posts/hello-world.md](content/posts/hello-world.md)
- [content/posts/tech-stack.md](content/posts/tech-stack.md)

## WordPress 备用方案

当前主方案是 Hugo 静态博客。以前保留的 WordPress 部署文件仍然在仓库里，如果以后需要浏览器后台写作，可以再考虑切换：

- [docs/wordpress-deploy.md](docs/wordpress-deploy.md)
- [deploy/nginx/wordpress.conf](deploy/nginx/wordpress.conf)
- [deploy/scripts/install-wordpress-ubuntu.sh](deploy/scripts/install-wordpress-ubuntu.sh)
