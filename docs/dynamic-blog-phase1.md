# KingHH 动态博客第一阶段说明

本阶段新增前后端分离博客系统，不删除当前 Hugo 静态博客。

## 当前范围

已完成：

- `blog-frontend`：Vue 3 + Vite + Vue Router + Pinia + Axios + Element Plus
- `blog-backend`：Spring Boot 3 + Spring Security + MyBatis Plus + MySQL
- 公开接口：
  - `GET /api/articles`
  - `GET /api/articles/{id}`
  - `GET /api/articles/search`
  - `GET /api/categories`
  - `GET /api/tags`
  - `GET /api/archives`
- 页面：
  - 首页
  - 文章列表页
  - 文章详情页
  - 分类、标签、归档、登录、注册等占位页
- 数据库：
  - 完整基础表结构：`blog-backend/src/main/resources/db/schema.sql`
  - 初始化数据：`blog-backend/src/main/resources/db/data.sql`
- 部署资产：
  - `Jenkinsfile.blog`
  - `deploy/blog/scripts/deploy.sh`
  - `deploy/blog/scripts/restart.sh`
  - `deploy/blog/nginx/kinghh-blog-app.conf`
  - `deploy/blog/systemd/kinghh-blog-api.service`
  - `deploy/blog/mysql/mysql-low-memory.cnf`

## 端口说明

需求里示例是 Spring Boot 监听 `127.0.0.1:8080`，但当前 VPS 上 Jenkins 已经使用 `8080`。

为了不影响 Jenkins，本方案部署时使用：

```text
Spring Boot: 127.0.0.1:18080
Nginx: /api -> 127.0.0.1:18080/api
```

## 数据库初始化

在 VPS 上安装 MySQL 8 后执行：

```bash
mysql -uroot -p < blog-backend/src/main/resources/db/schema.sql
mysql -uroot -p < blog-backend/src/main/resources/db/data.sql
```

创建业务账号示例：

```sql
create user if not exists 'kinghh_blog'@'127.0.0.1' identified by '请换成强密码';
grant all privileges on kinghh_blog.* to 'kinghh_blog'@'127.0.0.1';
flush privileges;
```

密码不要提交到 GitHub。生产环境放到：

```text
/etc/kinghh-blog/blog-api.env
```

示例：

```env
BLOG_DB_URL=jdbc:mysql://127.0.0.1:3306/kinghh_blog?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
BLOG_DB_USER=kinghh_blog
BLOG_DB_PASSWORD=请换成强密码
BLOG_JWT_SECRET=请换成至少32位随机字符串
SERVER_PORT=18080
```

## systemd 部署

```bash
sudo mkdir -p /etc/kinghh-blog /opt/blog/{backend,frontend/dist,logs,scripts,backup}
sudo cp deploy/blog/systemd/kinghh-blog-api.service /etc/systemd/system/kinghh-blog-api.service
sudo systemctl daemon-reload
sudo systemctl enable kinghh-blog-api
```

## Nginx 切换说明

第一阶段不要立即覆盖当前 Hugo 站点。建议先复制配置为测试站点，确认动态博客可用后再切换正式域名。

正式切换时：

```bash
sudo cp deploy/blog/nginx/kinghh-blog-app.conf /etc/nginx/sites-available/kinghh-blog-app
sudo ln -sfn /etc/nginx/sites-available/kinghh-blog-app /etc/nginx/sites-enabled/kinghh-blog-app
sudo nginx -t
sudo systemctl reload nginx
```

如果要替换现有 Hugo 配置，先备份：

```bash
sudo cp /etc/nginx/sites-available/kinghh-blog /etc/nginx/sites-available/kinghh-blog.bak.$(date +%Y%m%d%H%M%S)
```

## Jenkins

当前仓库根目录 `Jenkinsfile` 仍用于 Hugo 静态博客。

动态博客使用：

```text
Jenkinsfile.blog
```

建议在 Jenkins 新建一个独立 Job，Pipeline Script from SCM 指向 `Jenkinsfile.blog`，验证通过后再决定是否替换原 Job。

## 2G VPS 资源策略

- 不使用 Docker
- 不使用 Redis
- 不使用 Elasticsearch
- Spring Boot 使用 `-Xms256m -Xmx512m`
- MySQL buffer pool 建议 `256M`
- Jenkins 构建记录保留 10 条
- 前端构建产物由 Nginx 静态托管

## 后续阶段

第二阶段：注册、登录、JWT、个人中心、用户发布文章。

第三阶段：评论、点赞、收藏、分类、标签、搜索、归档。

第四阶段：后台管理系统。

第五阶段：UI、移动端、SEO、站点地图、性能和安全优化。
