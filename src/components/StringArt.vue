<template>
  <div class="string-art-container">
    <h2 class="page-title">钉子画绕线可视化演示</h2>
    <div class="json-upload">
      <label class="json-upload-label">
        <span class="json-upload-icon">📂</span>
        <span class="json-upload-text">加载 JSON 文件</span>
        <input type="file" accept="application/json" @change="onJsonFileChange" class="json-upload-input" />
      </label>
    </div>
  <canvas ref="canvasRef" :width="size" :height="size" style="width:100%;height:auto;max-width:100%;background:#fff;border-radius:8px;box-shadow:0 2px 8px #0001;margin-bottom:16px;"></canvas>
    <div class="controls">
      <button @click="prevStep" :disabled="currentStep <= 0 || steps.length === 0">上一步</button>
      <button @click="nextStep" :disabled="currentStep >= steps.length - 1 || steps.length === 0">下一步</button>
      <button @click="previewAll" style="margin-left:8px;" :disabled="steps.length === 0">预览</button>
      <span>当前步骤：{{ steps.length === 0 ? 0 : currentStep + 1 }} / {{ steps.length }}</span>
    </div>
    <div class="slider-row">
      <label for="lineWidthSlider">线条粗细：</label>
  <input id="lineWidthSlider" type="range" min="0.01" max="1" step="0.05" :value="lineWidth.value" @input="onLineWidthChange" />
      <span>{{ lineWidth.value }} px</span>
    </div>
  </div>
</template>

<script setup>
function onLineWidthChange(e) {
  lineWidth.value = Number(e.target.value)
  draw()
}
function previewAll() {
  if (!steps.value.length) return
  currentStep.value = steps.value.length - 1
  draw()
}
import { ref, onMounted, watch } from 'vue'

const loadedData = ref(null)

// 新增：动态 nails 和 steps
const nails = ref([])
const steps = ref([])
const size = ref(500) // 默认画布尺寸，后续可根据 json 动态调整
const currentStep = ref(0)

// 默认数据初始化
function setDefaultData() {
  const nailCount = 16
  size.value = 500
  nails.value = Array.from({ length: nailCount }, (_, i) => {
    const angle = (2 * Math.PI * i) / nailCount
    return {
      x: size.value / 2 + Math.cos(angle) * (size.value / 2 - 30),
      y: size.value / 2 + Math.sin(angle) * (size.value / 2 - 30)
    }
  })
  steps.value = [
    { from: 0, to: 8 },
    { from: 8, to: 4 },
    { from: 4, to: 12 },
    { from: 12, to: 2 },
    { from: 2, to: 10 },
    { from: 10, to: 6 },
    { from: 6, to: 14 },
    { from: 14, to: 0 }
  ]
}
setDefaultData()

function onJsonFileChange(e) {
  const file = e.target.files[0]
  if (!file) return
  const reader = new FileReader()
  reader.onload = function(evt) {
    try {
      loadedData.value = JSON.parse(evt.target.result)
      alert('JSON 文件加载成功！')
      applyJsonData(loadedData.value)
    } catch (err) {
      alert('JSON 文件解析失败！')
    }
  }
  reader.readAsText(file)
}

// 解析 JSON 文件内容并应用
function applyJsonData(data) {
  if (!data || !data.pins || !data.lines) return
  if (data.metadata && data.metadata.diameter) {
    size.value = Number(data.metadata.diameter)
  } else {
    size.value = 500
  }
  nails.value = data.pins.map(pin => ({ x: pin.x, y: pin.y }))
  steps.value = data.lines.map(line => ({ from: line.from, to: line.to }))
  currentStep.value = 0
  draw()
}

const canvasRef = ref(null)
const lineColor = ref('#e67e22')
const lineWidth = ref(2)
const nailColor = ref('#333')
const nailRadius = ref(4)

function drawNails(ctx) {
  nails.value.forEach(nail => {
    ctx.beginPath()
    ctx.arc(nail.x, nail.y, nailRadius.value, 0, 2 * Math.PI)
    ctx.fillStyle = nailColor.value
    ctx.fill()
  })
}

function drawLines(ctx) {
  for (let i = 0; i <= currentStep.value && i < steps.value.length; i++) {
    const step = steps.value[i]
    ctx.beginPath()
    ctx.moveTo(nails.value[step.from].x, nails.value[step.from].y)
    ctx.lineTo(nails.value[step.to].x, nails.value[step.to].y)
    ctx.strokeStyle = lineColor.value
    ctx.lineWidth = lineWidth.value
    ctx.stroke()
  }
}


function draw() {
  const canvas = canvasRef.value
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  ctx.clearRect(0, 0, size.value, size.value)
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
    if (i > targetStep || i >= steps.value.length) {
      drawNails(ctx)
      return
    }
    // 绘制已完成线
    for (let j = 0; j <= i; j++) {
      const step = steps.value[j]
      ctx.beginPath()
      ctx.moveTo(nails.value[step.from].x, nails.value[step.from].y)
      ctx.lineTo(nails.value[step.to].x, nails.value[step.to].y)
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
  if (!steps.value.length || stepIdx < 0 || stepIdx >= steps.value.length) return
  const text = `第${stepIdx + 1}步，从钉子${steps.value[stepIdx].from + 1}到钉子${steps.value[stepIdx].to + 1}`;
  if (window.speechSynthesis && window.SpeechSynthesisUtterance) {
    // 优先用原生 API
    try {
      const msg = new window.SpeechSynthesisUtterance(text);
      window.speechSynthesis.speak(msg);
    } catch (e) {
      if (window.JsSpeech) {
        window.JsSpeech.speak(text);
      }
    }
  } else if (window.JsSpeech) {
    window.JsSpeech.speak(text);
  }
}

function nextStep() {
  if (currentStep.value < steps.value.length - 1) {
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
/* 线条粗细滑块样式 */
.slider-row {
  margin: 12px 0 0 0;
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
}
input[type="range"] {
  width: 120px;
  accent-color: #e67e22;
}
/* 美化 JSON 文件上传按钮 */
.json-upload {
  margin-bottom: 16px;
  display: flex;
  justify-content: flex-start;
}
.json-upload-label {
  display: inline-flex;
  align-items: center;
  background: #e67e22;
  color: #fff;
  padding: 8px 18px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 16px;
  box-shadow: 0 2px 8px #0001;
  transition: background 0.2s;
}
.json-upload-label:hover {
  background: #cf711f;
}
.json-upload-icon {
  font-size: 20px;
  margin-right: 8px;
}
.json-upload-input {
  display: none;
}
.json-upload-text {
  font-weight: 500;
}
.string-art-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
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
