---
title: "我的博客技术栈：从静态页面开始"
date: 2026-06-24
description: "介绍 KingHH Blog 当前使用的技术栈：Hugo、Blowfish、VPS、Nginx、域名与 HTTPS。"
tags: ["hugo", "nginx", "vps", "blogging"]
categories: ["技术栈"]
featureimage: "tech-stack-feature.png"
aliases:
  - /posts/tech-stack.html
---

![Hugo、Blowfish、Nginx、VPS 与 HTTPS 组成的博客技术栈](/images/tech-stack-feature.png)

这个博客的第一版没有选择复杂平台，而是先用最稳定、最容易维护的方式上线：静态页面 + Nginx + VPS。

现在它已经迁移到 **Hugo + Blowfish**。这样既保留静态站点的速度和稳定性，也让后续写文章、加标签、生成 RSS 和站内搜索更方便。

## 当前使用的技术栈

服务器使用 Ubuntu，Web 服务使用 Nginx，静态页面由 Hugo 生成，主题使用 Blowfish。用户访问域名后，请求会先到 VPS，再由 Nginx 返回构建好的 HTML、CSS 和 JS。

| 技术 | 作用 |
| --- | --- |
| Ubuntu VPS | 承载站点服务，便于后续扩展后台、数据库或自动化部署 |
| Nginx | 接收 HTTP/HTTPS 请求，并直接返回静态站点文件 |
| Hugo | 将 Markdown 文章构建成静态页面 |
| Blowfish | 提供博客主题、文章列表、标签、搜索、RSS 和暗色模式 |
| Let’s Encrypt | 为 `kinghh.cn` 和 `www.kinghh.cn` 提供 HTTPS 证书 |

## 为什么迁移到 Hugo

纯 HTML 适合刚上线时验证方向，但文章数量增加后，手动维护列表、标签、RSS 和页面结构会变得重复。Hugo 可以把内容和主题分开：文章只写 Markdown，布局交给主题，部署时生成静态文件即可。

## 后续怎么扩展

如果文章数量变多，可以继续使用 Hugo 的分类、标签、RSS 和搜索能力。如果更需要后台写作体验，可以部署 WordPress。如果想练 Java，也可以在内容稳定后再做 Spring Boot + MySQL + Vue 的完整平台。

## 阶段目标

当前最重要的是先稳定上线、持续写内容、保持页面清爽。技术方案会跟着真实需求演进，而不是一开始就做成复杂系统。
