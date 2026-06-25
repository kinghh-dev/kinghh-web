<template>
  <article v-if="article" class="detail-page">
    <header class="detail-header">
      <RouterLink class="back-link" to="/articles">返回文章列表</RouterLink>
      <div class="detail-meta">
        <span>{{ article.categoryName }}</span>
        <span>{{ formatDate(article.publishedAt) }}</span>
        <span>{{ article.authorName }}</span>
      </div>
      <h1>{{ article.title }}</h1>
      <p>{{ article.summary }}</p>
      <div class="detail-stats">
        <span>浏览 {{ article.viewCount || 0 }}</span>
        <span>点赞 {{ article.likeCount || 0 }}</span>
        <span>评论 {{ article.commentCount || 0 }}</span>
        <span>收藏 {{ article.favoriteCount || 0 }}</span>
      </div>
    </header>

    <img class="detail-cover" :src="article.cover || fallbackCover" :alt="article.title" />

    <section class="markdown-body" v-html="html"></section>

    <footer class="detail-footer">
      <div class="tag-row">
        <span v-for="tag in article.tags || []" :key="tag"># {{ tag }}</span>
      </div>
      <div class="prev-next">
        <RouterLink v-if="article.previousId" :to="`/articles/${article.previousId}`">上一篇：{{ article.previousTitle }}</RouterLink>
        <RouterLink v-if="article.nextId" :to="`/articles/${article.nextId}`">下一篇：{{ article.nextTitle }}</RouterLink>
      </div>
    </footer>

    <section class="comment-placeholder">
      <h2>评论区</h2>
      <p>游客可以查看评论。登录评论、回复、点赞和收藏将在第三阶段接入。</p>
      <RouterLink to="/login">登录后参与讨论</RouterLink>
    </section>
  </article>
</template>

<script setup>
import MarkdownIt from 'markdown-it'
import { computed, onMounted, ref, watch } from 'vue'
import { fetchArticleDetail } from '@/api/blog'

const props = defineProps({
  id: {
    type: [String, Number],
    required: true
  }
})

const article = ref(null)
const md = new MarkdownIt({
  html: false,
  linkify: true,
  typographer: true
})
const fallbackCover = 'https://images.unsplash.com/photo-1499750310107-5fef28a66643?auto=format&fit=crop&w=1200&q=80'
const html = computed(() => md.render(article.value?.content || ''))

function formatDate(value) {
  if (!value) return ''
  return String(value).slice(0, 10)
}

async function load() {
  article.value = await fetchArticleDetail(props.id)
}

onMounted(load)
watch(() => props.id, load)
</script>
