# KingHH 博客评论系统说明

本项目使用 Waline 给 Hugo 静态博客增加文章评论功能。

## 当前方案

- 前端：Hugo `layouts/partials/comments.html`
- 后端：VPS 上的 Waline 服务
- 数据：SQLite 文件，存放在 VPS 的 `/var/lib/waline`
- 访问地址：`https://kinghh.cn/waline`
- 管理后台：`https://kinghh.cn/waline/ui`

Waline 只监听 VPS 本机的 `127.0.0.1:8360`，公网访问通过 Nginx 的 `/waline/` 反向代理进入。

## 本地 Hugo 配置

评论开关在 `config/_default/params.toml`：

```toml
[article]
  showComments = true

[comments]
  provider = "waline"

[comments.waline]
  serverURL = "https://kinghh.cn/waline"
  lang = "zh-CN"
  pageSize = 10
```

评论组件文件：

```text
layouts/partials/comments.html
```

Blowfish 主题的文章页已经预留了 `partials/comments.html`，所以项目只需要在 `layouts/partials/` 下新增同名 partial，不需要修改 `themes/blowfish`。

## 关闭某篇文章评论

在文章 front matter 中增加：

```yaml
comments: false
```

## VPS 文件位置

Waline 环境变量：

```text
/etc/waline/kinghh.env
```

这个文件权限是 `600`，不应提交到 GitHub。

Waline systemd 服务：

```text
/etc/systemd/system/kinghh-waline.service
```

SQLite 数据目录：

```text
/var/lib/waline
```

Nginx 反代配置：

```text
/etc/nginx/snippets/kinghh-waline.conf
```

站点配置会 include 这个 snippet：

```text
/etc/nginx/sites-available/kinghh-blog
```

## 常用维护命令

查看服务状态：

```bash
systemctl status kinghh-waline
```

查看日志：

```bash
journalctl -u kinghh-waline -n 100 --no-pager
```

重启服务：

```bash
systemctl restart kinghh-waline
```

测试本机服务：

```bash
curl -I http://127.0.0.1:8360/
```

测试 Nginx 反代：

```bash
curl -I https://kinghh.cn/waline/
```

## 评论审核

当前 VPS 环境变量里已开启：

```env
COMMENT_AUDIT=true
```

开启后，新评论不会直接展示，需要进入 Waline 管理后台审核。

首次访问 `https://kinghh.cn/waline/ui` 时，按 Waline 页面提示创建管理员账号。管理员密码不要写进仓库。

## 垃圾评论防护

当前基础防护：

- `COMMENT_AUDIT=true`：评论先审核
- `IPQPS=60`：限制同 IP 请求频率
- `SECURE_DOMAINS=kinghh.cn,www.kinghh.cn`：限制允许调用评论服务的站点域名
- 前端关闭图片上传：`imageUploader: false`

如果后续垃圾评论增多，可以继续接入 Cloudflare Turnstile。相关密钥应放在 `/etc/waline/kinghh.env`，不要提交到 GitHub。

## 数据备份

评论数据在 `/var/lib/waline`。建议把这个目录加入 VPS 备份。

示例：

```bash
tar -czf /root/waline-backup-$(date +%Y%m%d).tar.gz /var/lib/waline
```
