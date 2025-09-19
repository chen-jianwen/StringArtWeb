<template>
  <div class="main-bg">
    <nav class="main-navbar">
      <div class="main-logo">String Art</div>
      <div class="main-user">用户：{{ userInfo.name }} | 当前订单：{{ currentOrder.orderNo }}</div>
      <div class="main-music">
        <select v-model="music" class="music-select">
          <option v-for="m in musicList" :key="m" :value="m">{{ m }}</option>
        </select>
        <button class="music-btn" @click="toggleMute">{{ isMuted ? '🔇' : '🔊' }}</button>
      </div>
  <button v-if="isAdmin" class="main-admin" @click="goAdmin">后台管理</button>
  <button class="main-logout" @click="logout">退出</button>
    </nav>
    <div class="main-content">
      <aside class="main-orders">
        <h3>订单列表</h3>
        <ul>
          <li v-for="order in orders" :key="order.orderNo" :class="{active: order.orderNo === currentOrder.orderNo}" @click="selectOrder(order)">
            {{ order.orderNo }}
          </li>
        </ul>
      </aside>
      <section class="main-center">
        <div class="main-config">
          <label class="config-label">导入弦艺配置文件：</label>
          <input type="file" accept="application/json" @change="onConfigFileChange" />
        </div>
        <div class="main-guide">
          <h3>绕线指导</h3>
          <div class="guide-controls">
            <button @click="prevStep" :disabled="currentStep <= 0">上一步</button>
            <button @click="nextStep" :disabled="currentStep >= steps.length - 1">下一步</button>
            <button @click="pauseGuide">暂停</button>
            <button @click="interruptGuide">中断</button>
            <button @click="resumeGuide" :disabled="!isInterrupted">恢复</button>
          </div>
          <div class="guide-status">当前步骤：{{ currentStep + 1 }} / {{ steps.length }}</div>
        </div>
        <div class="main-art">
          <StringArt :config="currentConfig" :step="currentStep" />
        </div>
      </section>
    </div>
    <div v-if="showInterrupt" class="main-modal-bg">
      <div class="main-modal">
        <div class="modal-title">已中断，当前步骤：{{ currentStep + 1 }}</div>
        <button class="main-btn" @click="resumeGuide">继续指导</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import StringArt from './StringArt.vue'

// 示例用户和订单数据
const userInfo = ref({ name: '测试用户', isAdmin: true })
// 是否管理员
// const isAdmin = ref(userInfo.value.isAdmin)
const isAdmin = true
// const isAdmin = false



import { defineEmits } from 'vue'
const emit = defineEmits(['request-admin'])

function goAdmin() {
  emit('request-admin')
}
const orders = ref([
  { orderNo: 'ORD20250919001' },
  { orderNo: 'ORD20250919002' },
  { orderNo: 'ORD20250919003' }
])
const currentOrder = ref(orders.value[0])

// 配置文件与步骤
const currentConfig = ref(null)
const steps = ref([])
const currentStep = ref(0)

// 音乐相关
const musicList = ref(['音乐A', '音乐B', '音乐C'])
const music = ref(musicList.value[0])
const isMuted = ref(false)

// 指导状态
const isInterrupted = ref(false)
const showInterrupt = ref(false)

function selectOrder(order) {
  currentOrder.value = order
  // TODO: 加载对应订单配置和中断步骤
}
function onConfigFileChange(e) {
  const file = e.target.files[0]
  if (!file) return
  const reader = new FileReader()
  reader.onload = function(evt) {
    try {
      currentConfig.value = JSON.parse(evt.target.result)
      // TODO: 解析配置文件为步骤
      steps.value = currentConfig.value.lines || []
      currentStep.value = 0
      alert('配置文件加载成功！')
    } catch (err) {
      alert('配置文件解析失败！')
    }
  }
  reader.readAsText(file)
}
function prevStep() {
  if (currentStep.value > 0) currentStep.value--
}
function nextStep() {
  if (currentStep.value < steps.value.length - 1) currentStep.value++
}
function pauseGuide() {
  showInterrupt.value = true
  isInterrupted.value = true
}
function interruptGuide() {
  showInterrupt.value = true
  isInterrupted.value = true
  // TODO: 上传中断步骤到后端
}
function resumeGuide() {
  showInterrupt.value = false
  isInterrupted.value = false
}
function toggleMute() {
  isMuted.value = !isMuted.value
}
function logout() {
  window.location.reload()
}
</script>

<style scoped>
.main-bg {
  min-height: 100vh;
  background: linear-gradient(120deg, #3498db 0%, #ecf0f1 100%);
  font-family: "Microsoft YaHei", "Arial", "Helvetica Neue", Helvetica, sans-serif;
}
.main-navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fff;
  box-shadow: 0 2px 8px rgba(52,152,219,0.08);
  padding: 18px 32px;
  border-radius: 0 0 16px 16px;
  margin-bottom: 18px;
}
.main-logo {
  font-size: 1.5rem;
  font-weight: 700;
  color: #3498db;
}
.main-user {
  font-size: 1rem;
  color: #333;
}
.main-music {
  display: flex;
  align-items: center;
  gap: 8px;
}
.music-select {
  font-size: 1rem;
  border-radius: 6px;
  padding: 4px 12px;
}
.music-btn {
  background: #e67e22;
  color: #fff;
  border: none;
  border-radius: 6px;
  font-size: 1.2rem;
  padding: 4px 12px;
  cursor: pointer;
}
.main-admin {
  background: #3498db;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  padding: 8px 24px;
  cursor: pointer;
  margin-right: 12px;
}
.main-admin:hover {
  background: #e67e22;
}
.main-logout {
  background: #c0392b;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  padding: 8px 24px;
  cursor: pointer;
}
.main-content {
  display: flex;
  gap: 32px;
  justify-content: center;
  align-items: flex-start;
  max-width: 1200px;
  margin: 0 auto;
}
.main-orders {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(52,152,219,0.08);
  padding: 18px 12px;
  min-width: 180px;
}
.main-orders h3 {
  font-size: 1.1rem;
  color: #3498db;
  margin-bottom: 12px;
  text-align: center;
}
.main-orders ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
.main-orders li {
  padding: 8px 0;
  text-align: center;
  cursor: pointer;
  border-radius: 6px;
  margin-bottom: 6px;
  transition: background 0.2s;
}
.main-orders li.active, .main-orders li:hover {
  background: #e67e22;
  color: #fff;
}
.main-center {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 18px;
}
.main-config {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(52,152,219,0.08);
  padding: 18px 12px;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 12px;
}
.config-label {
  font-size: 1rem;
  color: #333;
}
.main-guide {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(52,152,219,0.08);
  padding: 18px 12px;
  margin-bottom: 8px;
}
.guide-controls {
  display: flex;
  gap: 12px;
  margin-bottom: 8px;
}
.guide-controls button {
  background: #3498db;
  color: #fff;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  padding: 8px 18px;
  cursor: pointer;
  transition: background 0.2s;
}
.guide-controls button:disabled {
  background: #ccc;
  color: #fff;
  cursor: not-allowed;
}
.guide-status {
  font-size: 1rem;
  color: #e67e22;
  margin-top: 6px;
}
.main-art {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(52,152,219,0.08);
  padding: 18px 12px;
  margin-bottom: 8px;
}
.main-modal-bg {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(52,152,219,0.12);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}
.main-modal {
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
.modal-title {
  font-size: 1.2rem;
  color: #3498db;
  text-align: center;
  margin-bottom: 18px;
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
@media (max-width: 900px) {
  .main-content {
    flex-direction: column;
    gap: 16px;
    max-width: 98vw;
  }
  .main-orders {
    min-width: 100%;
    margin-bottom: 12px;
  }
  .main-center {
    gap: 12px;
  }
}
@media (max-width: 600px) {
  .main-navbar {
    flex-direction: column;
    gap: 8px;
    padding: 10px 8px;
    border-radius: 0 0 10px 10px;
  }
  .main-content {
    flex-direction: column;
    gap: 8px;
    max-width: 99vw;
  }
  .main-orders {
    min-width: 100%;
    margin-bottom: 8px;
    padding: 10px 4px;
  }
  .main-center {
    gap: 8px;
  }
  .main-config, .main-guide, .main-art {
    padding: 10px 4px;
    border-radius: 8px;
  }
  .main-btn {
    font-size: 15px;
    padding: 8px;
    border-radius: 6px;
    width: 98vw;
    max-width: 180px;
  }
  .main-modal {
    padding: 12px 4vw 12px 4vw;
    min-width: 180px;
  }
  .modal-title {
    font-size: 1rem;
    margin-bottom: 10px;
  }
}
</style>
