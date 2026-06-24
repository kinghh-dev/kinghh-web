# Jenkins 自动部署 Hugo 静态站点

这套配置适合当前 `kinghh-web` 工程：Jenkins 检测 Git 分支提交，自动执行 Hugo 构建，并把 `public/` 同步到 VPS 的 `/var/www/kinghh-blog`。

## 1. VPS 准备

先完成一次基础 Nginx 初始化：

```bash
export BLOG_DOMAIN="kinghh.cn"
export BLOG_WWW_DOMAIN="www.kinghh.cn"
sudo -E bash deploy/scripts/deploy-static-ubuntu.sh
```

如果 DNS 已经解析到 VPS，再申请 HTTPS：

```bash
sudo certbot --nginx -d kinghh.cn -d www.kinghh.cn
```

## 2. Jenkins 准备

Jenkins 机器需要安装：

```bash
sudo apt update
sudo apt install -y git curl tar rsync nginx
```

如果 Jenkins 和网站在同一台 VPS，给 Jenkins 用户配置发布权限：

```bash
sudo visudo
```

加入：

```text
jenkins ALL=(root) NOPASSWD: /usr/bin/rsync, /usr/bin/mkdir, /usr/bin/chown, /usr/bin/find, /usr/sbin/nginx, /usr/bin/systemctl
```

不同系统命令路径可能不同，可以用 `which rsync mkdir chown find nginx systemctl` 确认。

## 3. 创建 Jenkins Pipeline

1. 新建任务，类型选 `Pipeline`。
2. `Pipeline` 选择 `Pipeline script from SCM`。
3. SCM 选择 `Git`，填入仓库地址。
4. Branch 填 `*/main` 或你的实际发布分支。
5. Script Path 填 `Jenkinsfile`。
6. 保存。

`Jenkinsfile` 已经配置了 `pollSCM('H/2 * * * *')`，Jenkins 会大约每 2 分钟检查一次 Git 是否有新提交。

更推荐的方式是配置 Git webhook，让仓库 push 后立即触发 Jenkins。轮询作为兜底方案保留。

## 4. 日常发布流程

本地修改代码后：

```bash
git add .
git commit -m "Update blog content"
git push origin main
```

Jenkins 检测到 `main` 分支新提交后会自动：

1. 拉取代码。
2. 下载或复用 Hugo Extended `0.161.1`。
3. 执行 `hugo --gc --minify`。
4. 用 `rsync --delete` 发布 `public/` 到 `/var/www/kinghh-blog`。
5. 校验并 reload Nginx。

## 5. 手动一键发布

如果你已经登录 VPS 并拉好了代码，也可以手动执行：

```bash
HUGO_VERSION=0.161.1 SITE_ROOT=/var/www/kinghh-blog bash deploy/scripts/jenkins-deploy-static.sh all
```
