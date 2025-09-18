<script setup>
import StringArt from './components/StringArt.vue'
import Login from './components/Login.vue'
import { ref } from 'vue'

const isLoggedIn = ref(false)

function handleLoginSuccess() {
  isLoggedIn.value = true
}
</script>

<template>
  <div>
    <Login v-if="!isLoggedIn" @login-success="handleLoginSuccess" />
    <StringArt v-else />
  </div>
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
