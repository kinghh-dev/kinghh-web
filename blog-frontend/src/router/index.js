import { createRouter, createWebHistory } from 'vue-router'
import PublicLayout from '@/layouts/PublicLayout.vue'
import HomeView from '@/views/HomeView.vue'
import ArticleListView from '@/views/ArticleListView.vue'
import ArticleDetailView from '@/views/ArticleDetailView.vue'
import PlaceholderView from '@/views/PlaceholderView.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      component: PublicLayout,
      children: [
        { path: '', name: 'home', component: HomeView },
        { path: 'articles', name: 'articles', component: ArticleListView },
        { path: 'articles/:id', name: 'article-detail', component: ArticleDetailView, props: true },
        { path: 'categories', component: PlaceholderView, props: { title: '分类', message: '分类聚合将在第三阶段完善。' } },
        { path: 'tags', component: PlaceholderView, props: { title: '标签', message: '标签聚合将在第三阶段完善。' } },
        { path: 'archives', component: PlaceholderView, props: { title: '归档', message: '归档页将在第三阶段完善。' } },
        { path: 'friends', component: PlaceholderView, props: { title: '友情链接', message: '友情链接管理将在第四阶段完善。' } },
        { path: 'about', component: PlaceholderView, props: { title: '关于我', message: '关于我内容后续接入网站配置。' } },
        { path: 'login', component: PlaceholderView, props: { title: '登录', message: '注册登录将在第二阶段实现。' } },
        { path: 'register', component: PlaceholderView, props: { title: '注册', message: '注册登录将在第二阶段实现。' } }
      ]
    },
    { path: '/:pathMatch(.*)*', redirect: '/' }
  ],
  scrollBehavior() {
    return { top: 0 }
  }
})

export default router
