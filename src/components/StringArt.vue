<template>
  <div class="string-art-container">
  <h2 class="page-title">钉子画绕线可视化演示</h2>
    <canvas ref="canvasRef" :width="size" :height="size" style="width:100%;height:auto;max-width:100%;background:#a64c4c;border-radius:8px;box-shadow:0 2px 8px #0001;margin-bottom:16px;"></canvas>
    <div class="controls">
      <button @click="prevStep" :disabled="currentStep <= 0">上一步</button>
      <button @click="nextStep" :disabled="currentStep >= steps.length - 1">下一步</button>
      <span>当前步骤：{{ currentStep + 1 }} / {{ steps.length }}</span>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'

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

const canvasRef = ref(null)
const lineColor = ref('#e67e22')
const lineWidth = ref(2)
const nailColor = ref('#333')
const nailRadius = ref(4)

function drawNails(ctx) {
  nails.forEach(nail => {
    ctx.beginPath()
    ctx.arc(nail.x, nail.y, nailRadius.value, 0, 2 * Math.PI)
    ctx.fillStyle = nailColor.value
    ctx.fill()
  })
}

function drawLines(ctx) {
  for (let i = 0; i <= currentStep.value && i < steps.length; i++) {
    const step = steps[i]
    ctx.beginPath()
    ctx.moveTo(nails[step.from].x, nails[step.from].y)
    ctx.lineTo(nails[step.to].x, nails[step.to].y)
    ctx.strokeStyle = lineColor.value
    ctx.lineWidth = lineWidth.value
    ctx.stroke()
  }
}


function draw() {
  const canvas = canvasRef.value
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  ctx.clearRect(0, 0, size, size)
  drawLines(ctx)
  drawNails(ctx)
}

// 预留动画接口
function animateDrawLines(targetStep) {
  const canvas = canvasRef.value
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  ctx.clearRect(0, 0, size, size)
  let i = 0
  function stepDraw() {
    if (i > targetStep || i >= steps.length) {
      drawNails(ctx)
      return
    }
    // 绘制已完成线
    for (let j = 0; j <= i; j++) {
      const step = steps[j]
      ctx.beginPath()
      ctx.moveTo(nails[step.from].x, nails[step.from].y)
      ctx.lineTo(nails[step.to].x, nails[step.to].y)
      ctx.strokeStyle = lineColor.value
      ctx.lineWidth = lineWidth.value
      ctx.stroke()
    }
    drawNails(ctx)
    i++
    requestAnimationFrame(stepDraw)
  }
  stepDraw()
}
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

onMounted(() => {
  draw();
});

watch(currentStep, () => {
  draw();
});
</script>

<style scoped>
.string-art-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
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
/* PC和移动端自适应样式 */
.string-art-container {
  width: 100%;
  max-width: 400px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16px;
}
svg {
  width: 100%;
  height: auto;
  max-width: 100%;
  background: #a64c4c;
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
@media (max-width: 600px) {
  .string-art-container {
    max-width: 100vw;
    padding: 8px;
  }
  .controls {
    flex-direction: column;
    gap: 8px;
  }
  button {
    font-size: 14px;
    padding: 8px 12px;
  }
}
</style>
