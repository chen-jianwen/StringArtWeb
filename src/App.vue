<script setup>
import StringArt from './components/StringArt.vue'
</script>

<template>
  <StringArt />
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
