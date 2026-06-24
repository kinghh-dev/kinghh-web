# Hugo 静态博客部署说明

当前项目使用 Hugo 和 Blowfish 主题构建静态博客。

## 目录结构

```text
config/_default/      Hugo 和 Blowfish 配置
content/              Markdown 页面和文章
assets/               Hugo 处理的源资源
static/               原样复制到站点的静态资源
themes/blowfish/      当前使用的 Blowfish 主题
public/               构建结果，不提交到 Git
```

## 写文章

在 `content/posts/` 下创建 Markdown 文件：

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

## 构建

安装 Hugo Extended `0.161.1` 后执行：

```bash
hugo --gc --minify
```

生成文件会放到：

```text
public/
```

## 部署

自动部署推荐走 Jenkins。手动部署时，先确保 VPS 上有仓库代码或已经上传了 `public/` 目录，然后执行：

```bash
cd /root/kinghh-web
export BLOG_DOMAIN="kinghh.cn"
export BLOG_WWW_DOMAIN="www.kinghh.cn"
sudo -E bash deploy/scripts/deploy-static-ubuntu.sh
```

线上站点目录是：

```text
/var/www/kinghh-blog
```

HTTPS 由 Certbot 管理：

```bash
sudo certbot --nginx -d kinghh.cn -d www.kinghh.cn
```

## 和 WordPress 的取舍

Hugo 的优点：

- 静态页面访问速度快。
- 不需要数据库。
- 文章使用 Markdown 管理，适合开发者。
- RSS、分类、标签、搜索索引都可以构建生成。
- 维护成本和安全风险更低。

Hugo 的限制：

- 没有浏览器后台。
- 发布前需要构建。
- 评论需要外部服务或自建服务。

当前博客主要是个人写作和技术记录，因此 Hugo 更合适。只有当“浏览器后台写作”比“简单稳定”更重要时，再考虑 WordPress。
