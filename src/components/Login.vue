<template>
  <div class="login-bg">
    <div class="login-container">
      <h2 class="login-title">String Art 登录</h2>
      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-group">
          <label for="phone">手机号</label>
          <input id="phone" v-model="phone" type="text" maxlength="20" placeholder="请输入手机号（必填）" required />
        </div>
        <div class="form-group">
          <label for="orderNo">订单号</label>
          <input id="orderNo" v-model="orderNo" type="text" maxlength="32" placeholder="可选，输入订单号" />
        </div>
        <button type="submit" class="main-btn">登录</button>
      </form>
      <div class="guest-login">
        <button class="main-btn" @click="handleGuestLogin">以游客身份进入</button>
      </div>
      <p v-if="error" class="error">{{ error }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const phone = ref('')
const orderNo = ref('')
const error = ref('')
const router = useRouter()

function handleLogin() {
  if (!phone.value) {
    error.value = '请输入手机号'
    return
  }
  // 演示，实际应调用后端接口
  if (phone.value === '13800000000' || orderNo.value === 'ORD20250919001') {
    error.value = ''
    // 登录成功后跳转主界面或画廊
    router.push('/main')
  } else {
    error.value = '手机号或订单号错误'
  }
}

function handleGuestLogin() {
  error.value = ''
  router.push('/gallery')
}
</script>

<style scoped>
/* 背景渐变美化，主色蓝色 */
.login-bg {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(120deg, #3498db 0%, #ecf0f1 100%);
}
 .login-container {
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 24px rgba(0,0,0,0.10);
  padding: 40px 32px 32px 32px;
  width: 350px;
  max-width: 95vw;
  margin: 32px 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  font-family: "Microsoft YaHei", "Arial", "Helvetica Neue", Helvetica, sans-serif;
 }
 .login-title {
  font-size: 2rem;
  font-weight: 700;
  color: #3498db;
  margin-bottom: 28px;
  letter-spacing: 2px;
 }
.login-tabs {
  display: flex;
  justify-content: space-between;
  width: 100%;
  margin-bottom: 24px;
}
.login-tabs button {
  width: 32%;
  background: #f4f4f4;
  color: #333;
  border: 1px solid #ccc;
  border-radius: 8px 8px 0 0;
  font-size: 15px;
  padding: 10px 0;
  margin-right: 0;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
  outline: none;
  font-family: inherit;
}
.login-tabs button.active {
  background: #3498db;
  color: #fff;
  border: 1px solid #3498db;
}
.login-form {
  width: 100%;
  margin-top: 8px;
}
.form-group {
  margin-bottom: 18px;
  display: flex;
  flex-direction: column;
}
.form-group label {
  font-size: 15px;
  color: #555;
  margin-bottom: 6px;
  font-family: inherit;
}
input {
  width: 100%;
  padding: 10px 12px;
  border-radius: 6px;
  border: 1px solid #e0e0e0;
  font-size: 16px;
  background: #fafafa;
  transition: border 0.2s;
  font-family: inherit;
}
input:focus {
  border: 1.5px solid #3498db;
  outline: none;
}
 .main-btn {
  width: 100%;
  padding: 12px;
  background: linear-gradient(90deg, #e67e22 60%, #f4f4f4 100%);
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 17px;
  font-weight: 600;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(52,152,219,0.08);
  margin-top: 8px;
  transition: background 0.2s;
  font-family: inherit;
 }
.main-btn:hover {
  background: linear-gradient(90deg, #e67e22 60%, #3498db 100%);
}
.main-btn:disabled {
  background: #ccc;
  color: #fff;
  cursor: not-allowed;
}
.guest-login {
  text-align: center;
  margin-top: 24px;
  width: 100%;
}
 .error {
  color: #c0392b;
  margin-top: 18px;
  font-size: 15px;
  text-align: center;
  font-family: inherit;
 }

@media (max-width: 600px) {
  .login-container {
    width: 95vw;
    padding: 18px 6vw 16px 6vw;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  }
  .login-title {
    font-size: 1.3rem;
    margin-bottom: 16px;
  }
  .login-tabs button {
    font-size: 13px;
    padding: 8px 0;
    border-radius: 6px 6px 0 0;
  }
  .form-group label {
    font-size: 13px;
    margin-bottom: 4px;
  }
  input {
    font-size: 14px;
    padding: 8px 8px;
    border-radius: 5px;
  }
  .main-btn {
    font-size: 15px;
    padding: 10px;
    border-radius: 6px;
    margin-top: 6px;
  }
  .error {
    font-size: 13px;
    margin-top: 10px;
  }
}
</style>
