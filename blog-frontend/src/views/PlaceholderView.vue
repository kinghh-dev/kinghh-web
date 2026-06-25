<template>
  <section class="placeholder-page">
    <p class="eyebrow">Coming Soon</p>
    <h1>{{ title }}</h1>
    <p>{{ message }}</p>
    <RouterLink class="primary-button" to="/">回到首页</RouterLink>
  </section>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    default: '功能建设中'
  },
  message: {
    type: String,
    default: '该模块会在后续阶段继续完善。'
  }
})
</script>
