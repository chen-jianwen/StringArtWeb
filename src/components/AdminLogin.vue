<template>
  <div class="admin-login-bg">
    <div class="admin-login-card">
      <h2>后台管理员登录</h2>
      <form @submit.prevent="handleLogin">
        <input v-model="phone" type="text" placeholder="手机号" maxlength="20" required />
        <input v-model="password" type="password" placeholder="密码" required />
        <button class="admin-login-btn" :disabled="loading">{{ loading ? '登录中...' : '登录' }}</button>
        <div v-if="error" class="admin-login-error">{{ error }}</div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const phone = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)
const router = useRouter()

async function handleLogin() {
  error.value = ''
  loading.value = true
  // 假设调用后端API /api/login，返回用户信息
  try {
    // 这里用fetch举例，实际可用axios
    const res = await fetch('/api/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ phone: phone.value, password: password.value })
    })
    const data = await res.json()
    if (data.code === 0 && data.data.is_admin) {
      localStorage.setItem('user', JSON.stringify(data.data))
      router.push('/admin')
    } else {
      error.value = data.msg || '登录失败或无管理员权限'
    }
  } catch (e) {
    error.value = '网络错误，请重试'
  }
  loading.value = false
}
</script>

<style scoped>
.admin-login-bg {
  min-height: 100vh;
  background: linear-gradient(120deg, #3498db 0%, #ecf0f1 100%);
  display: flex;
  align-items: center;
  justify-content: center;
}
.admin-login-card {
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 24px rgba(52,152,219,0.12);
  padding: 40px 32px 32px 32px;
  min-width: 320px;
  max-width: 90vw;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.admin-login-card h2 {
  color: #3498db;
  margin-bottom: 24px;
}
.admin-login-card input {
  width: 220px;
  padding: 10px;
  border-radius: 6px;
  border: 1px solid #e0e0e0;
  font-size: 16px;
  margin-bottom: 18px;
  background: #f4f4f4;
  transition: border 0.2s;
}
.admin-login-card input:focus {
  border: 1.5px solid #3498db;
  background: #fff;
  outline: none;
}
.admin-login-btn {
  width: 220px;
  background: linear-gradient(90deg, #e67e22 0%, #f39c12 100%);
  color: #fff;
  border: none;
  border-radius: 6px;
  font-size: 17px;
  font-weight: 600;
  padding: 10px 0;
  cursor: pointer;
  margin-bottom: 10px;
  transition: background 0.2s;
}
.admin-login-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}
.admin-login-error {
  color: #c0392b;
  text-align: center;
  margin-top: 8px;
  font-size: 15px;
}
@media (max-width: 600px) {
  .admin-login-card, .admin-login-card input, .admin-login-btn {
    width: 98vw;
    min-width: 180px;
    max-width: 320px;
  }
}
</style>
