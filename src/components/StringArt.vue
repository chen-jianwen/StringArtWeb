<template>
  <div class="string-art-container">
    <svg :width="size" :height="size">
      <!-- 钉子 -->
      <circle v-for="(nail, idx) in nails" :key="idx" :cx="nail.x" :cy="nail.y" r="4" fill="#333" />
      <!-- 绕线 -->
      <line v-for="(step, idx) in steps.slice(0, currentStep+1)" :key="idx" :x1="nails[step.from].x" :y1="nails[step.from].y" :x2="nails[step.to].x" :y2="nails[step.to].y" stroke="#e67e22" stroke-width="2" />
    </svg>
    <div class="controls">
      <button @click="nextStep" :disabled="currentStep >= steps.length - 1">下一步</button>
      <button @click="prevStep" :disabled="currentStep <= 0">上一步</button>
      <span>当前步骤：{{ currentStep + 1 }} / {{ steps.length }}</span>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const size = 400
const nailCount = 16
const nails = Array.from({ length: nailCount }, (_, i) => {
  const angle = (2 * Math.PI * i) / nailCount
  return {
    x: size / 2 + Math.cos(angle) * (size / 2 - 30),
    y: size / 2 + Math.sin(angle) * (size / 2 - 30)
  }
})
// 示例绕线步骤（可扩展为算法生成）
const steps = [
  { from: 0, to: 8 },
  { from: 8, to: 4 },
  { from: 4, to: 12 },
  { from: 12, to: 2 },
  { from: 2, to: 10 },
  { from: 10, to: 6 },
  { from: 6, to: 14 },
  { from: 14, to: 0 }
]
const currentStep = ref(0)

function speakStep(stepIdx) {
  const msg = new window.SpeechSynthesisUtterance(`第${stepIdx + 1}步，从钉子${steps[stepIdx].from + 1}到钉子${steps[stepIdx].to + 1}`)
  window.speechSynthesis.speak(msg)
}

function nextStep() {
  if (currentStep.value < steps.length - 1) {
    currentStep.value++
    speakStep(currentStep.value)
  }
}
function prevStep() {
  if (currentStep.value > 0) {
    currentStep.value--
    speakStep(currentStep.value)
  }
}
// 初始播报
speakStep(currentStep.value)
</script>

<style scoped>
.string-art-container {
  display: flex;
  flex-direction: column;
  align-items: center;
}
svg {
  background: #fafafa;
  border-radius: 8px;
  box-shadow: 0 2px 8px #0001;
  margin-bottom: 16px;
}
.controls {
  display: flex;
  gap: 12px;
  align-items: center;
}
button {
  padding: 6px 16px;
  font-size: 16px;
  border-radius: 4px;
  border: none;
  background: #e67e22;
  color: #fff;
  cursor: pointer;
}
button:disabled {
  background: #ccc;
  cursor: not-allowed;
}
</style>
