# WordPress 部署说明

这是备用方案。当前项目主方案是 Hugo 静态博客；只有在以后明确需要浏览器后台写作、插件生态或动态内容时，才建议切换到 WordPress。

执行命令前，请把下面的示例值替换成你自己的信息：

- `example.com`：主域名
- `www.example.com`：可选的 `www` 域名
- `1.2.3.4`：VPS 公网 IP
- `CHANGE_ME_STRONG_PASSWORD`：MySQL 强密码

## 1. DNS 解析

在域名服务商的 DNS 控制台添加：

```text
Type: A
Host: @
Value: 1.2.3.4
```

如果需要 `www`：

```text
Type: A
Host: www
Value: 1.2.3.4
```

等待 DNS 解析到 VPS：

```bash
nslookup example.com
nslookup www.example.com
```

## 2. 安装服务

登录 VPS：

```bash
ssh root@1.2.3.4
```

把仓库或至少 `deploy/scripts` 目录复制到 VPS。例如在本地执行：

```bash
scp -r deploy root@1.2.3.4:/root/kinghh-web-deploy
```

然后在 VPS 上进入目录：

```bash
cd /root/kinghh-web-deploy
```

设置自己的参数并执行安装脚本：

```bash
export BLOG_DOMAIN="example.com"
export BLOG_WWW_DOMAIN="www.example.com"
export WP_DB_NAME="wordpress"
export WP_DB_USER="wpuser"
export WP_DB_PASSWORD="CHANGE_ME_STRONG_PASSWORD"

bash deploy/scripts/install-wordpress-ubuntu.sh
```

为了让脚本处理更简单，数据库密码不要包含单引号。如果你只复制了脚本，请在脚本所在目录执行，并相应调整脚本路径。

## 3. 手动配置 Nginx

如果不使用脚本，可以把 `deploy/nginx/wordpress.conf` 复制到：

```text
/etc/nginx/sites-available/blog
```

然后替换：

- `example.com www.example.com`
- `/run/php/php8.3-fpm.sock`，如果你的 PHP 版本不同

查看当前 PHP-FPM socket：

```bash
ls /run/php/
```

启用站点：

```bash
sudo ln -s /etc/nginx/sites-available/blog /etc/nginx/sites-enabled/blog
sudo nginx -t
sudo systemctl reload nginx
```

## 4. HTTPS

确认 DNS 已经指向 VPS，并且 Nginx 可以正常访问后，执行：

```bash
sudo certbot --nginx -d example.com -d www.example.com
```

Certbot 提示是否开启 HTTP 到 HTTPS 跳转时，选择开启。

测试证书续期：

```bash
sudo certbot renew --dry-run
```

## 5. 初始化 WordPress

浏览器打开：

```text
https://example.com
```

数据库信息填写：

```text
数据库名：wordpress
数据库用户：wpuser
数据库密码：CHANGE_ME_STRONG_PASSWORD
数据库主机：localhost
表前缀：wp_
```

后台地址：

```text
https://example.com/wp-admin
```

## 6. 首次设置建议

建议先做这些设置：

- 固定链接设置为文章名。
- 删除默认文章和页面。
- 选择一个简单主题。
- 只安装必要插件。
- 备份 MySQL 和 `/var/www/blog/wp-content`。

常见插件类别：

- 缓存
- SEO
- 备份
- 如果开启评论，再安装反垃圾评论插件

## 7. 备份目标

最重要的数据是：

```text
/var/www/blog/wp-content
MySQL database: wordpress
```

数据库导出示例：

```bash
mysqldump -u wpuser -p wordpress > wordpress-backup.sql
```
