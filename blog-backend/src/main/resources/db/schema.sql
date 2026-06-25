create database if not exists kinghh_blog
  default character set utf8mb4
  default collate utf8mb4_0900_ai_ci;

use kinghh_blog;

create table if not exists user (
  id bigint primary key auto_increment,
  username varchar(64) not null unique,
  email varchar(128) not null unique,
  password varchar(120) not null,
  nickname varchar(64) not null,
  avatar varchar(500) null,
  bio varchar(500) null,
  role varchar(32) not null default 'USER',
  status varchar(32) not null default 'NORMAL',
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0,
  index idx_user_role (role),
  index idx_user_status (status),
  index idx_user_deleted (deleted)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

create table if not exists category (
  id bigint primary key auto_increment,
  name varchar(64) not null,
  slug varchar(80) not null unique,
  description varchar(300) null,
  sort_order int not null default 0,
  status varchar(32) not null default 'NORMAL',
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0,
  index idx_category_status (status),
  index idx_category_sort (sort_order)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

create table if not exists tag (
  id bigint primary key auto_increment,
  name varchar(64) not null,
  slug varchar(80) not null unique,
  status varchar(32) not null default 'NORMAL',
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0,
  index idx_tag_status (status)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

create table if not exists article (
  id bigint primary key auto_increment,
  title varchar(160) not null,
  summary varchar(500) null,
  content mediumtext not null,
  cover varchar(500) null,
  author_id bigint not null,
  category_id bigint null,
  status varchar(32) not null default 'DRAFT',
  is_top tinyint(1) not null default 0,
  is_recommend tinyint(1) not null default 0,
  view_count bigint not null default 0,
  like_count bigint not null default 0,
  comment_count bigint not null default 0,
  favorite_count bigint not null default 0,
  published_at datetime null,
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0,
  constraint fk_article_author foreign key (author_id) references user(id),
  constraint fk_article_category foreign key (category_id) references category(id),
  index idx_article_status_pub (status, published_at),
  index idx_article_author (author_id),
  index idx_article_category (category_id),
  index idx_article_flags (is_top, is_recommend),
  fulltext index ft_article_search (title, summary, content)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

create table if not exists article_tag (
  id bigint primary key auto_increment,
  article_id bigint not null,
  tag_id bigint not null,
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0,
  unique key uk_article_tag (article_id, tag_id),
  constraint fk_article_tag_article foreign key (article_id) references article(id),
  constraint fk_article_tag_tag foreign key (tag_id) references tag(id),
  index idx_article_tag_tag (tag_id)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

create table if not exists comment (
  id bigint primary key auto_increment,
  article_id bigint not null,
  user_id bigint not null,
  parent_id bigint null,
  content varchar(2000) not null,
  status varchar(32) not null default 'NORMAL',
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0,
  constraint fk_comment_article foreign key (article_id) references article(id),
  constraint fk_comment_user foreign key (user_id) references user(id),
  index idx_comment_article (article_id, status, created_at),
  index idx_comment_user (user_id)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

create table if not exists favorite (
  id bigint primary key auto_increment,
  article_id bigint not null,
  user_id bigint not null,
  status varchar(32) not null default 'NORMAL',
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0,
  unique key uk_favorite_user_article (user_id, article_id),
  constraint fk_favorite_article foreign key (article_id) references article(id),
  constraint fk_favorite_user foreign key (user_id) references user(id)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

create table if not exists article_like (
  id bigint primary key auto_increment,
  article_id bigint not null,
  user_id bigint not null,
  status varchar(32) not null default 'NORMAL',
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0,
  unique key uk_like_user_article (user_id, article_id),
  constraint fk_like_article foreign key (article_id) references article(id),
  constraint fk_like_user foreign key (user_id) references user(id)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

create table if not exists site_config (
  id bigint primary key auto_increment,
  config_key varchar(100) not null unique,
  config_value text null,
  description varchar(300) null,
  status varchar(32) not null default 'NORMAL',
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

create table if not exists friend_link (
  id bigint primary key auto_increment,
  name varchar(100) not null,
  url varchar(500) not null,
  logo varchar(500) null,
  description varchar(300) null,
  sort_order int not null default 0,
  status varchar(32) not null default 'NORMAL',
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

create table if not exists operation_log (
  id bigint primary key auto_increment,
  user_id bigint null,
  operation varchar(120) not null,
  target_type varchar(64) null,
  target_id bigint null,
  ip varchar(64) null,
  user_agent varchar(500) null,
  status varchar(32) not null default 'SUCCESS',
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0,
  index idx_operation_user (user_id),
  index idx_operation_created (created_at)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

create table if not exists login_log (
  id bigint primary key auto_increment,
  user_id bigint null,
  username varchar(64) null,
  ip varchar(64) null,
  user_agent varchar(500) null,
  status varchar(32) not null,
  message varchar(300) null,
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0,
  index idx_login_user (user_id),
  index idx_login_created (created_at)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

create table if not exists message (
  id bigint primary key auto_increment,
  user_id bigint null,
  nickname varchar(64) null,
  email varchar(128) null,
  content varchar(2000) not null,
  status varchar(32) not null default 'NORMAL',
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  deleted tinyint not null default 0
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci;

