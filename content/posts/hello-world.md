---
title: "第一篇文章：博客上线"
date: 2026-06-23
description: "从一个最小可用的静态页面开始，把写作和发布流程先跑通。"
tags: ["blogging", "deployment"]
categories: ["博客"]
aliases:
  - /posts/hello-world.html
---

这是一篇示例文章。它的作用是验证页面样式、文章排版和 VPS 静态部署流程。

第一版博客不需要复杂系统。把首页、文章页、关于页和部署流程跑通之后，就可以开始持续写内容。

## 当前方案

最初版本使用纯静态文件，由 Nginx 直接返回页面，不需要数据库、PHP 或后台服务。它的资源占用低，迁移和备份也很简单。

## 后续扩展

随着文章数量增加，博客已经迁移到 Hugo。后续如果更需要后台写作体验，可以部署 WordPress；如果想练 Java，也可以在内容稳定后再做 Spring Boot + MySQL + Vue 的完整平台。
