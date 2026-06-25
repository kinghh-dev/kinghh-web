import http from './http'

export function fetchArticles(params = {}) {
  return http.get('/articles', { params })
}

export function fetchArticleDetail(id) {
  return http.get(`/articles/${id}`)
}

export function fetchCategories() {
  return http.get('/categories')
}

export function fetchTags() {
  return http.get('/tags')
}

export function fetchArchives() {
  return http.get('/archives')
}
