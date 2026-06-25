<template>
  <div class="site-shell">
    <header class="site-header">
      <RouterLink class="brand" to="/">
        <span class="brand-mark">K</span>
        <span>
          <strong>KingHH Blog</strong>
          <small>技术探索与轻社区</small>
        </span>
      </RouterLink>
      <nav class="nav-links">
        <RouterLink to="/">首页</RouterLink>
        <RouterLink to="/articles">文章</RouterLink>
        <RouterLink to="/categories">分类</RouterLink>
        <RouterLink to="/tags">标签</RouterLink>
        <RouterLink to="/archives">归档</RouterLink>
        <RouterLink to="/about">关于</RouterLink>
      </nav>
      <div class="header-actions">
        <RouterLink class="ghost-link" to="/login">登录</RouterLink>
        <RouterLink class="primary-link" to="/register">开始写作</RouterLink>
      </div>
    </header>

    <main>
      <RouterView />
    </main>

    <footer class="site-footer">
      <div>
        <strong>KingHH Blog</strong>
        <p>一个面向个人主站和用户自由发布文章的轻社区博客。</p>
      </div>
      <div class="footer-links">
        <RouterLink to="/friends">友情链接</RouterLink>
        <RouterLink to="/about">关于我</RouterLink>
      </div>
    </footer>
  </div>
</template>
