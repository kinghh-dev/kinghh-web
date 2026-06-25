<template>
  <section class="page-hero small">
    <p class="eyebrow">Articles</p>
    <h1>文章广场</h1>
    <p>浏览所有已发布文章。后续普通用户发布的文章会直接出现在这里。</p>
    <div class="list-search">
      <input v-model="query.keyword" placeholder="搜索文章标题、摘要或正文" @keyup.enter="loadArticles(1)" />
      <button @click="loadArticles(1)">搜索</button>
    </div>
  </section>

  <section class="list-layout">
    <aside class="filter-panel">
      <h3>分类</h3>
      <button :class="{ active: !query.categoryId }" @click="setCategory(null)">全部文章</button>
      <button v-for="item in categories" :key="item.id" :class="{ active: query.categoryId === item.id }" @click="setCategory(item.id)">
        {{ item.name }} <span>{{ item.articleCount }}</span>
      </button>
      <h3>热门标签</h3>
      <div class="tag-cloud">
        <button v-for="tag in tags" :key="tag.id" :class="{ active: query.tagId === tag.id }" @click="setTag(tag.id)">
          #{{ tag.name }}
        </button>
      </div>
    </aside>

    <div class="article-list-main">
      <div class="list-toolbar">
        <span>共 {{ total }} 篇文章</span>
        <select v-model="query.sort" @change="loadArticles(1)">
          <option value="latest">最新发布</option>
          <option value="hot">热门浏览</option>
        </select>
      </div>
      <div class="article-grid list">
        <ArticleCard v-for="article in articles" :key="article.id" :article="article" />
      </div>
      <div class="pagination-bar" v-if="total > query.size">
        <button :disabled="query.page <= 1" @click="loadArticles(query.page - 1)">上一页</button>
        <span>第 {{ query.page }} 页</span>
        <button :disabled="query.page * query.size >= total" @click="loadArticles(query.page + 1)">下一页</button>
      </div>
    </div>
  </section>
</template>

<script setup>
import { onMounted, reactive, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import ArticleCard from '@/components/ArticleCard.vue'
import { fetchArticles, fetchCategories, fetchTags } from '@/api/blog'

const route = useRoute()
const query = reactive({
  page: 1,
  size: 9,
  keyword: '',
  categoryId: null,
  tagId: null,
  sort: 'latest'
})
const articles = ref([])
const total = ref(0)
const categories = ref([])
const tags = ref([])

async function loadArticles(page = query.page) {
  query.page = page
  const data = await fetchArticles({
    ...query,
    categoryId: query.categoryId || undefined,
    tagId: query.tagId || undefined,
    keyword: query.keyword || undefined
  })
  articles.value = data.records || []
  total.value = data.total || 0
}

function setCategory(id) {
  query.categoryId = id
  query.tagId = null
  loadArticles(1)
}

function setTag(id) {
  query.tagId = query.tagId === id ? null : id
  loadArticles(1)
}

onMounted(async () => {
  query.keyword = route.query.keyword || ''
  query.categoryId = route.query.categoryId ? Number(route.query.categoryId) : null
  query.tagId = route.query.tagId ? Number(route.query.tagId) : null
  const [categoryData, tagData] = await Promise.all([fetchCategories(), fetchTags()])
  categories.value = categoryData || []
  tags.value = tagData || []
  loadArticles(1)
})

watch(() => route.query, () => {
  query.keyword = route.query.keyword || ''
  query.categoryId = route.query.categoryId ? Number(route.query.categoryId) : null
  query.tagId = route.query.tagId ? Number(route.query.tagId) : null
  loadArticles(1)
})
</script>
