<script setup>
import Main from './components/Main.vue'
import Login from './components/Login.vue'
import Gallery from './components/Gallery.vue'
import Admin from './components/Admin.vue'
import { ref } from 'vue'

const loginType = ref('none') // 'none' | 'user' | 'phone' | 'guest' | 'admin'

function handleLoginSuccess(payload) {
  if (payload && payload.type === 'guest') {
    loginType.value = 'guest'
  } else {
    loginType.value = 'user'
  }
}

function handleRequestAdmin() {
  loginType.value = 'admin'
}
</script>

<template>
  <router-view />
</template>

<style scoped>
body, html {
  margin: 0;
  padding: 0;
  width: 100%;
  min-height: 100vh;
  background: #f8f8f8;
}

#app {
  width: 100%;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: flex-start;
}

@media (max-width: 600px) {
  #app {
    padding: 0;
    align-items: stretch;
  }
}
</style>
