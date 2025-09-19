<template>
  <div class="gallery-bg">
    <div class="gallery-container">
      <h2 class="gallery-title">弦艺作品画廊</h2>
      <div class="gallery-grid">
        <div v-for="item in galleryList" :key="item.id" class="gallery-card" @click="openPreview(item)">
          <img :src="item.img" :alt="item.title" class="gallery-img" />
          <div class="gallery-card-title">{{ item.title }}</div>
        </div>
      </div>
  <button class="gallery-login-btn" @click="goLogin">登录</button>
    </div>
    <div v-if="showPreview" class="gallery-modal-bg" @click.self="closePreview">
      <div class="gallery-modal">
        <img :src="previewItem.img" :alt="previewItem.title" class="gallery-modal-img" />
        <div class="gallery-modal-title">{{ previewItem.title }}</div>
        <button class="main-btn gallery-modal-close" @click="closePreview">关闭预览</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

// 示例数据，后续可用API替换
const galleryList = ref(Array.from({ length: 30 }, (_, i) => ({
  id: i + 1,
  title: `作品${String.fromCharCode(65 + (i % 26))}${i >= 26 ? i - 25 : ''}`,
  img: `/public/img/${String.fromCharCode(97 + (i % 26))}${i >= 26 ? i - 25 : ''}.png`
})))

const showPreview = ref(false)
const previewItem = ref({})

function openPreview(item) {
  previewItem.value = item
  showPreview.value = true
}
function closePreview() {
  showPreview.value = false
}
function goLogin() {
  // 触发父组件切换到登录界面
  // 推荐用事件通知 App.vue
  // 这里用 $emit 兼容性写法
  // 如果用props可改为 props.onLogin()
  // 但setup语法下需 defineEmits
  emit('request-login')
}

import { defineEmits } from 'vue'
const emit = defineEmits(['request-login'])
</script>

<style scoped>
.gallery-login-btn {
  position: absolute;
  top: 24px;
  right: 32px;
  background: linear-gradient(90deg, #3498db 60%, #e67e22 100%);
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  padding: 8px 24px;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(52,152,219,0.08);
  z-index: 10;
  font-family: inherit;
  transition: background 0.2s;
}
.gallery-login-btn:hover {
  background: linear-gradient(90deg, #e67e22 60%, #3498db 100%);
}
.gallery-bg {
  min-height: 100vh;
  background: linear-gradient(120deg, #3498db 0%, #ecf0f1 100%);
  display: flex;
  align-items: center;
  justify-content: center;
}
.gallery-container {
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 24px rgba(0,0,0,0.10);
  padding: 32px 24px 24px 24px;
  width: 900px;
  max-width: 98vw;
  margin: 32px 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  font-family: "Microsoft YaHei", "Arial", "Helvetica Neue", Helvetica, sans-serif;
}
.gallery-title {
  font-size: 2rem;
  font-weight: 700;
  color: #3498db;
  margin-bottom: 28px;
  letter-spacing: 2px;
  text-align: center;
}
.gallery-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  grid-template-rows: repeat(6, 1fr);
  gap: 24px;
  width: 100%;
  margin-bottom: 32px;
}
.gallery-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(52,152,219,0.08);
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16px 8px 12px 8px;
}
.gallery-card:hover {
  transform: scale(1.04);
  box-shadow: 0 4px 16px rgba(52,152,219,0.15);
}
.gallery-img {
  width: 100%;
  max-width: 180px;
  aspect-ratio: 1 / 1;
  object-fit: cover;
  border-radius: 8px;
  margin-bottom: 10px;
  background: #f4f4f4;
}
.gallery-card-title {
  font-size: 1rem;
  color: #333;
  text-align: center;
  margin-top: 4px;
}
.main-btn {
  width: 180px;
  padding: 12px;
  background: linear-gradient(90deg, #e67e22 60%, #3498db 100%);
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
  background: linear-gradient(90deg, #e67e22 60%, #f4f4f4 100%);
}
.gallery-back {
  margin-top: 0;
}
.gallery-modal-bg {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(52,152,219,0.12);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}
.gallery-modal {
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 24px rgba(0,0,0,0.15);
  padding: 32px 24px 24px 24px;
  min-width: 320px;
  max-width: 90vw;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.gallery-modal-img {
  width: 100%;
  max-width: 320px;
  height: 220px;
  object-fit: cover;
  border-radius: 10px;
  margin-bottom: 16px;
  background: #f4f4f4;
}
.gallery-modal-title {
  font-size: 1.2rem;
  color: #3498db;
  text-align: center;
  margin-bottom: 18px;
}
.gallery-modal-close {
  width: 120px;
  margin-top: 0;
}
@media (max-width: 1200px) {
  .gallery-container {
    width: 98vw;
    padding: 18px 2vw 16px 2vw;
  }
  .gallery-grid {
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: auto;
    gap: 16px;
  }
  .gallery-img {
    max-width: 120px;
    aspect-ratio: 1 / 1;
  }
}
@media (max-width: 600px) {
  .gallery-container {
    width: 99vw;
    padding: 10px 1vw 10px 1vw;
    border-radius: 10px;
  }
  .gallery-title {
    font-size: 1.2rem;
    margin-bottom: 12px;
  }
  .gallery-grid {
    grid-template-columns: 1fr;
    grid-template-rows: auto;
    gap: 10px;
  }
  .gallery-card {
    padding: 10px 4px 8px 4px;
    border-radius: 8px;
  }
  .gallery-img {
    max-width: 98vw;
    aspect-ratio: 1 / 1;
  }
  .main-btn {
    font-size: 15px;
    padding: 8px;
    border-radius: 6px;
    width: 98vw;
    max-width: 180px;
  }
  .gallery-modal {
    padding: 12px 4vw 12px 4vw;
    min-width: 180px;
  }
  .gallery-modal-img {
    max-width: 98vw;
    aspect-ratio: 1 / 1;
  }
  .gallery-modal-title {
    font-size: 1rem;
    margin-bottom: 10px;
  }
  .gallery-modal-close {
    width: 98vw;
    max-width: 120px;
    font-size: 14px;
  }
}
</style>
