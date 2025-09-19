import { createRouter, createWebHistory } from 'vue-router'
import Login from '../components/Login.vue'
import Gallery from '../components/Gallery.vue'
import Main from '../components/Main.vue'
import Admin from '../components/Admin.vue'

const routes = [
  { path: '/login', component: Login },
  { path: '/gallery', component: Gallery },
  { path: '/main', component: Main },
  { path: '/admin', component: Admin, meta: { requiresAdmin: true } },
  { path: '/admin-login', name: 'AdminLogin', component: () => import('../components/AdminLogin.vue'), meta: { hidden: true } },
  { path: '/', redirect: '/login' },
]

const router = createRouter({
  history: createWebHistory('/StringArtWeb/'),
  routes,
})

// 路由守卫：后台管理页面仅管理员可访问
router.beforeEach((to, from, next) => {
  const user = JSON.parse(localStorage.getItem('user')) // 登录后保存的用户信息
  if (to.meta.requiresAdmin) {
    if (user && user.is_admin) {
      next()
    } else {
      next('/login') // 非管理员自动跳转登录页
    }
  } else {
    next()
  }
})

export default router
