<template>
  <section class="hero-section">
    <div class="hero-copy">
      <p class="eyebrow">Vue + Spring Boot + MySQL</p>
      <h1>KingHH Blog</h1>
      <p class="hero-text">个人主站 + 用户自由发布文章的轻社区博客。游客自由阅读，登录用户自由发表文章。</p>
      <div class="hero-search">
        <input v-model="keyword" type="search" placeholder="搜索技术实践、AI 工具、部署经验..." @keyup.enter="goSearch" />
        <button @click="goSearch">搜索</button>
      </div>
      <div class="hero-actions">
        <RouterLink to="/articles" class="primary-button">浏览文章</RouterLink>
        <RouterLink to="/register" class="secondary-button">注册发布</RouterLink>
      </div>
    </div>
    <div class="hero-panel">
      <span class="panel-label">今日主线</span>
      <h2>从静态博客升级到轻社区</h2>
      <p>第一阶段先保证首页、列表、详情和部署链路稳定，后续逐步接入用户发布、评论、收藏和后台管理。</p>
    </div>
  </section>

  <section class="content-band">
    <div class="section-title">
      <div>
        <p class="eyebrow">Latest</p>
        <h2>最新文章</h2>
      </div>
      <RouterLink to="/articles">查看全部</RouterLink>
    </div>
    <div class="article-grid">
      <ArticleCard v-for="article in latestArticles" :key="article.id" :article="article" />
    </div>
  </section>

  <section class="split-band">
    <div>
      <div class="section-title compact">
        <div>
          <p class="eyebrow">Popular</p>
          <h2>热门文章</h2>
        </div>
      </div>
      <div class="rank-list">
        <RouterLink v-for="(article, index) in hotArticles" :key="article.id" :to="`/articles/${article.id}`">
          <span>{{ String(index + 1).padStart(2, '0') }}</span>
          <strong>{{ article.title }}</strong>
          <small>{{ article.viewCount || 0 }} 浏览</small>
        </RouterLink>
      </div>
    </div>
    <div>
      <div class="section-title compact">
        <div>
          <p class="eyebrow">Explore</p>
          <h2>分类与标签</h2>
        </div>
      </div>
      <div class="taxonomy-box">
        <RouterLink v-for="category in categories" :key="category.id" :to="`/articles?categoryId=${category.id}`">
          {{ category.name }} <span>{{ category.articleCount }}</span>
        </RouterLink>
      </div>
      <div class="tag-cloud">
        <RouterLink v-for="tag in tags" :key="tag.id" :to="`/articles?tagId=${tag.id}`">#{{ tag.name }}</RouterLink>
      </div>
    </div>
  </section>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import ArticleCard from '@/components/ArticleCard.vue'
import { fetchArticles, fetchCategories, fetchTags } from '@/api/blog'

const router = useRouter()
const keyword = ref('')
const latestArticles = ref([])
const hotArticles = ref([])
const categories = ref([])
const tags = ref([])

function goSearch() {
  router.push({ path: '/articles', query: keyword.value ? { keyword: keyword.value } : {} })
}

onMounted(async () => {
  const [latest, hot, categoryData, tagData] = await Promise.all([
    fetchArticles({ page: 1, size: 6 }),
    fetchArticles({ page: 1, size: 5, sort: 'hot' }),
    fetchCategories(),
    fetchTags()
  ])
  latestArticles.value = latest.records || []
  hotArticles.value = hot.records || []
  categories.value = categoryData || []
  tags.value = (tagData || []).slice(0, 16)
})
</script>
