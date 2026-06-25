<template>
  <article class="article-card" @click="$router.push(`/articles/${article.id}`)">
    <div class="cover-wrap">
      <img :src="article.cover || fallbackCover" :alt="article.title" />
      <span v-if="article.categoryName" class="category-pill">{{ article.categoryName }}</span>
    </div>
    <div class="card-body">
      <div class="card-meta">
        <span>{{ article.authorName || '匿名作者' }}</span>
        <span>{{ formatDate(article.publishedAt) }}</span>
      </div>
      <h3>{{ article.title }}</h3>
      <p>{{ article.summary }}</p>
      <div class="tag-row">
        <span v-for="tag in article.tags || []" :key="tag"># {{ tag }}</span>
      </div>
      <div class="stat-row">
        <span>浏览 {{ article.viewCount || 0 }}</span>
        <span>点赞 {{ article.likeCount || 0 }}</span>
        <span>评论 {{ article.commentCount || 0 }}</span>
      </div>
    </div>
  </article>
</template>

<script setup>
defineProps({
  article: {
    type: Object,
    required: true
  }
})

const fallbackCover = 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=900&q=80'

function formatDate(value) {
  if (!value) return '未发布'
  return String(value).slice(0, 10)
}
</script>
