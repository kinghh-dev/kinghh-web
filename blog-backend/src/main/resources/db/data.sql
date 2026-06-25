use kinghh_blog;

insert into user (id, username, email, password, nickname, avatar, bio, role, status)
values
  (1, 'admin', 'admin@kinghh.cn', '$2a$10$hG/wFbrQdK3Db6T23LKDuO5gMc0Y9dY6z21Jv.Sd5uZqQ3uB1v71m', 'KingHH', '/images/avatar-profile-20260624.png', '站长，记录技术探索和长期思考。', 'ADMIN', 'NORMAL'),
  (2, 'demo_user', 'demo@kinghh.cn', '$2a$10$hG/wFbrQdK3Db6T23LKDuO5gMc0Y9dY6z21Jv.Sd5uZqQ3uB1v71m', '示例作者', null, '热爱写作和分享的普通用户。', 'USER', 'NORMAL')
on duplicate key update updated_at = current_timestamp;

insert into category (id, name, slug, description, sort_order, status)
values
  (1, '技术实践', 'tech', '工程实践、部署、后端和前端开发记录。', 1, 'NORMAL'),
  (2, 'AI 工具', 'ai-tools', 'AI 工具、生产力和工作流探索。', 2, 'NORMAL'),
  (3, '随笔思考', 'notes', '长期主义、阅读和个人思考。', 3, 'NORMAL')
on duplicate key update updated_at = current_timestamp;

insert into tag (id, name, slug, status)
values
  (1, 'Java', 'java', 'NORMAL'),
  (2, 'Vue', 'vue', 'NORMAL'),
  (3, 'VPS', 'vps', 'NORMAL'),
  (4, 'AI', 'ai', 'NORMAL'),
  (5, '博客系统', 'blog-system', 'NORMAL')
on duplicate key update updated_at = current_timestamp;

insert into article
  (id, title, summary, content, cover, author_id, category_id, status, is_top, is_recommend,
   view_count, like_count, comment_count, favorite_count, published_at)
values
  (1, '从 Hugo 到前后端分离博客系统',
   '这篇文章记录 KingHH Blog 从静态博客升级为 Vue + Spring Boot + MySQL 的第一步。',
   '# 从 Hugo 到前后端分离博客系统\n\n第一阶段先完成首页、文章列表和文章详情，让系统具备可访问、可部署、可扩展的基础。\n\n```java\nSystem.out.println(\"KingHH Blog\");\n```\n\n后续会逐步增加注册登录、用户发布文章、评论、收藏和后台管理。',
   'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1200&q=80',
   1, 1, 'PUBLISHED', 1, 1, 128, 12, 0, 5, now() - interval 2 day),
  (2, '2G VPS 上的轻量 Java 博客部署思路',
   '在 2G 内存 VPS 上部署 Java、MySQL、Nginx 和 Jenkins，需要控制 JVM、MySQL 和构建资源。',
   '# 2G VPS 上的轻量 Java 博客部署思路\n\n第一版不使用 Docker、Redis、Elasticsearch 和消息队列。Spring Boot 使用 `-Xms256m -Xmx512m`，MySQL 使用轻量配置，前端由 Nginx 直接托管。\n\n这样可以把资源留给真正的访问请求。',
   'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=1200&q=80',
   1, 1, 'PUBLISHED', 0, 1, 86, 9, 0, 3, now() - interval 1 day),
  (3, '普通用户自由发布文章的设计边界',
   '这个博客不是单人 CMS，而是个人主站加轻社区，普通用户发布后直接展示。',
   '# 普通用户自由发布文章的设计边界\n\n文章状态只有草稿、已发布、已下架、已删除。没有审核流程。\n\n管理员负责治理内容，而不是成为每篇文章的发布闸门。',
   'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1200&q=80',
   2, 3, 'PUBLISHED', 0, 0, 42, 4, 0, 2, now())
on duplicate key update updated_at = current_timestamp;

insert into article_tag (article_id, tag_id)
values
  (1, 1), (1, 2), (1, 5),
  (2, 1), (2, 3),
  (3, 5), (3, 4)
on duplicate key update updated_at = current_timestamp;

insert into site_config (config_key, config_value, description, status)
values
  ('site_name', 'KingHH Blog', '博客名称', 'NORMAL'),
  ('site_description', '记录 AI 浪潮下的技术探索、工程实践和长期思考。', '博客简介', 'NORMAL'),
  ('home_hero_title', 'KingHH Blog', '首页主标题', 'NORMAL'),
  ('home_hero_subtitle', '个人主站 + 用户自由发布文章的轻社区博客。', '首页副标题', 'NORMAL'),
  ('seo_keywords', 'Java,Vue,Spring Boot,个人博客,AI', 'SEO 关键词', 'NORMAL')
on duplicate key update config_value = values(config_value), updated_at = current_timestamp;

insert into friend_link (name, url, description, sort_order, status)
values
  ('Hugo', 'https://gohugo.io/', '静态站点生成器', 1, 'NORMAL'),
  ('Spring', 'https://spring.io/', 'Java 应用开发生态', 2, 'NORMAL'),
  ('Vue', 'https://vuejs.org/', '渐进式前端框架', 3, 'NORMAL')
on duplicate key update updated_at = current_timestamp;
