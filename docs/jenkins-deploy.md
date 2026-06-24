# Jenkins 自动部署 Hugo 静态站点

这篇文档记录当前 `kinghh-web` 项目的自动部署方式。目标是：你在本地修改内容并推送到 GitHub 后，Jenkins 自动拉取代码、执行 Hugo 构建，并把生成的静态页面发布到 VPS。

当前线上 Jenkins 地址：

```text
https://kinghh.cn/jenkins/login
```

当前发布分支：

```text
master
```

当前网站目录：

```text
/var/www/kinghh-blog
```

## 1. 整体流程

日常发布链路如下：

```text
本地修改代码
-> git commit
-> git push origin master
-> Jenkins 检测到 master 分支新提交
-> Jenkins 拉取最新代码
-> 执行 Hugo 构建
-> 同步 public/ 到 /var/www/kinghh-blog
-> Nginx 重新加载
-> 网站更新
```

## 2. 本地发布步骤

修改文章、首页或配置后，在本地执行：

```bash
git add .
git commit -m "更新博客内容"
git push origin master
```

Jenkins 会大约每 2 分钟检查一次 GitHub 是否有新提交。也可以登录 Jenkins 后手动点击 `Build Now` 立即构建。

## 3. Jenkins 任务

Jenkins 任务名称：

```text
kinghh-web
```

任务配置来自仓库根目录的：

```text
Jenkinsfile
```

`Jenkinsfile` 会执行两个主要阶段：

```text
Build  -> Hugo 构建
Deploy -> 发布到 VPS 网站目录
```

## 4. 查看构建进度

打开：

```text
https://kinghh.cn/jenkins/login
```

登录后进入：

```text
kinghh-web
```

查看构建日志：

```text
构建编号 -> Console Output
```

如果构建成功，日志末尾会看到：

```text
Finished: SUCCESS
```

## 5. VPS 基础初始化

如果以后重装 VPS，需要先初始化 Nginx 静态站点：

```bash
export BLOG_DOMAIN="kinghh.cn"
export BLOG_WWW_DOMAIN="www.kinghh.cn"
sudo -E bash deploy/scripts/deploy-static-ubuntu.sh
```

如果 DNS 已经解析到 VPS，再申请 HTTPS：

```bash
sudo certbot --nginx -d kinghh.cn -d www.kinghh.cn
```

## 6. Jenkins 安装

如果以后重装 Jenkins，可以在 VPS 上执行：

```bash
sudo bash deploy/scripts/install-jenkins-ubuntu.sh
```

安装完成后，原始访问地址通常是：

```text
http://VPS-IP:8080
```

当前项目已经额外配置了 Nginx 反向代理，所以推荐使用：

```text
https://kinghh.cn/jenkins/login
```

## 7. Jenkins 发布权限

Jenkins 需要把构建产物同步到 `/var/www/kinghh-blog`，因此 VPS 上给 `jenkins` 用户配置了有限的免密 `sudo` 权限：

```text
jenkins ALL=(root) NOPASSWD: /usr/bin/rsync, /usr/bin/mkdir, /usr/bin/chown, /usr/bin/find, /usr/sbin/nginx, /usr/bin/systemctl
```

这个权限只用于发布静态站点、调整文件权限、检查并重载 Nginx。

## 8. 手动一键发布

如果你已经登录 VPS，并且仓库代码已经是最新，也可以手动执行：

```bash
HUGO_VERSION=0.161.1 SITE_ROOT=/var/www/kinghh-blog bash deploy/scripts/jenkins-deploy-static.sh all
```

## 9. 常见问题

如果网站没有更新，先检查 Jenkins 是否有新的构建记录。

如果没有构建记录，通常是 Jenkins 还没有检测到 GitHub 新提交，或者 Jenkins 任务没有正常运行。可以进入 `kinghh-web` 任务，手动点击 `Build Now`。

如果构建失败，进入失败的构建编号，打开 `Console Output`，优先看日志最后 30 行。

如果 Jenkins 页面显示很简陋，通常是 Nginx 反向代理没有正确转发 Jenkins 的静态资源。当前已经通过 `location ^~ /jenkins/` 修正。
