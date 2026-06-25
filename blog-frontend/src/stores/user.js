import { defineStore } from 'pinia'

export const useUserStore = defineStore('user', {
  state: () => ({
    token: localStorage.getItem('blog_token') || '',
    user: null
  }),
  getters: {
    isLoggedIn: (state) => Boolean(state.token),
    isAdmin: (state) => state.user?.role === 'ADMIN'
  },
  actions: {
    setToken(token) {
      this.token = token
      localStorage.setItem('blog_token', token)
    },
    logout() {
      this.token = ''
      this.user = null
      localStorage.removeItem('blog_token')
    }
  }
})
