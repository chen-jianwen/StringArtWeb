<template>
  <div class="login-container">
    <h2>登录</h2>
    <form @submit.prevent="handleLogin">
      <div class="form-group">
        <label for="username">用户名</label>
        <input id="username" v-model="username" type="text" required />
      </div>
      <div class="form-group">
        <label for="password">密码</label>
        <input id="password" v-model="password" type="password" required />
      </div>
      <button type="submit">登录</button>
    </form>
    <p v-if="error" class="error">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref, defineEmits } from 'vue'

const username = ref('')
const password = ref('')
const error = ref('')
const emit = defineEmits(['login-success'])

function handleLogin() {
  if (!username.value || !password.value) {
    error.value = '请输入用户名和密码'
    return
  }
  // 简单演示，实际应调用后端接口
  if (username.value === 'admin' && password.value === '123456') {
    error.value = ''
    emit('login-success')
  } else {
    error.value = '用户名或密码错误'
  }
}
</script>

<style scoped>
input {
  width: 100%;
  padding: 8px;
  border-radius: 4px;
  border: 1px solid #ccc;
  font-size: 16px;
}
button {
  width: 100%;
  padding: 10px;
  background: #e67e22;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
}
button:hover {
  background: #d35400;
}
.error {
  color: #c0392b;
  margin-top: 12px;
}
</style>
