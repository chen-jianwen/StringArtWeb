<template>
  <div class="admin-bg">
    <nav class="admin-navbar">
      <div class="admin-logo">String Art 后台</div>
      <div class="admin-user">管理员：admin</div>
      <div class="admin-tabs">
        <button :class="{active: tab==='order'}" @click="tab='order'">订单管理</button>
        <button :class="{active: tab==='gallery'}" @click="tab='gallery'">画廊管理</button>
        <button :class="{active: tab==='stats'}" @click="tab='stats'">数据统计</button>
      </div>
      <button class="admin-logout" @click="logout">退出</button>
    </nav>
    <div class="admin-content">
      <!-- 用户管理tab已移除 -->
      <section v-if="tab==='order'" class="admin-table-section">
        <h3>订单管理</h3>
        <button class="admin-btn" @click="showOrderForm=true">新增订单</button>
        <table class="admin-table">
          <thead>
            <tr>
              <th>ID</th><th>订单号</th><th>手机号</th><th>用户名</th><th>价格</th><th>创建时间</th><th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="order in orders" :key="order.id">
              <td>{{ order.id }}</td>
              <td>{{ order.order_no }}</td>
              <td>{{ order.phone }}</td>
              <td>{{ getUsername(order.phone) }}</td>
              <td>{{ order.price }}</td>
              <td>{{ order.create_time }}</td>
              <td>
                <button class="admin-btn" @click="editOrder(order)">编辑</button>
                <button class="admin-btn admin-btn-danger" @click="deleteOrder(order)">删除</button>
              </td>
            </tr>
          </tbody>
        </table>
      </section>
      <section v-if="tab==='gallery'" class="admin-table-section">
        <h3>画廊管理</h3>
        <button class="admin-btn" @click="showGalleryForm=true">新增作品</button>
        <table class="admin-table">
          <thead>
            <tr>
              <th>ID</th><th>标题</th><th>预览图</th><th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in gallery" :key="item.id">
              <td>{{ item.id }}</td>
              <td>{{ item.title }}</td>
              <td><img :src="item.img" alt="预览" class="gallery-thumb" /></td>
              <td>
                <button class="admin-btn" @click="editGallery(item)">编辑</button>
                <button class="admin-btn admin-btn-danger" @click="deleteGallery(item)">删除</button>
              </td>
            </tr>
          </tbody>
        </table>
      </section>
      <section v-if="tab==='stats'" class="admin-table-section">
        <h3>数据统计</h3>
        <div class="stats-chart">（此处可集成图表库展示订单数量、收入等统计数据）</div>
      </section>
    </div>
    <!-- 新增/编辑订单弹窗（唯一） -->
    <div v-if="showOrderForm" class="admin-modal-bg">
      <div class="admin-modal">
        <h4>新增/编辑订单</h4>
        <form @submit.prevent="handleOrderAdd">
          <input v-model="orderForm.order_no" placeholder="订单号" required />
          <input v-model="orderForm.phone" placeholder="手机号" required />
          <input v-model="orderForm.username" placeholder="用户名（可选）" />
          <input v-model="orderForm.price" type="number" placeholder="价格" required />
          <input type="file" accept=".json" @change="handleOrderFileChange" required />
          <button class="admin-btn" type="submit">提交</button>
          <button class="admin-btn" type="button" @click="showOrderForm=false">取消</button>
        </form>
      </div>
    </div>
    <!-- 画廊表单弹窗 -->
    <div v-if="showGalleryForm" class="admin-modal-bg">
      <div class="admin-modal">
        <h4>新增/编辑作品</h4>
        <form @submit.prevent="saveGallery">
          <input v-model="galleryForm.title" placeholder="标题" required />
          <input v-model="galleryForm.img" placeholder="图片地址" required />
          <button class="admin-btn" type="submit">保存</button>
          <button class="admin-btn" type="button" @click="showGalleryForm=false">取消</button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tab = ref('order')
const showOrderForm = ref(false)
const showGalleryForm = ref(false)

// 示例数据
const users = ref([
  { id: 1, phone: '13800000000', username: 'userA', orders: ['ORD20250919001'], create_time: '2025-09-01' },
  { id: 2, phone: '13900000001', username: 'userB', orders: ['ORD20250919002','ORD20250919003'], create_time: '2025-09-02' }
])
const orders = ref([
  { id: 1, order_no: 'ORD20250919001', phone: '13800000000', price: 99, create_time: '2025-09-01' },
  { id: 2, order_no: 'ORD20250919002', phone: '13900000001', price: 199, create_time: '2025-09-02' }
])
const gallery = ref([
  { id: 1, title: '作品A', img: '/public/img/a.png' },
  { id: 2, title: '作品B', img: '/public/img/b.png' }
])

// 订单表单数据（合并用户信息）
const orderForm = ref({ order_no: '', phone: '', username: '', price: '', config: null })

function getUsername(phone) {
  const user = users.value.find(u => u.phone === phone)
  return user ? user.username : ''
}

function handleOrderFileChange(e) {
  const file = e.target.files[0]
  orderForm.value.config = file
}

function handleOrderAdd() {
  if (!orderForm.value.phone || !orderForm.value.order_no || !orderForm.value.price || !orderForm.value.config) {
    alert('请填写手机号、订单号、价格并上传配置文件')
    return
  }
  // 查找用户是否存在
  let user = users.value.find(u => u.phone === orderForm.value.phone)
  if (!user) {
    // 新用户，自动添加
    const newUser = {
      id: users.value.length + 1,
      phone: orderForm.value.phone,
      username: orderForm.value.username || '',
      orders: [orderForm.value.order_no],
      create_time: new Date().toISOString().slice(0,10)
    }
    users.value.push(newUser)
  } else {
    // 老用户，新增订单号
    user.orders.push(orderForm.value.order_no)
    // 用户名可更新
    if (orderForm.value.username) user.username = orderForm.value.username
  }
  // 新增订单
  const newOrder = {
    id: orders.value.length + 1,
    order_no: orderForm.value.order_no,
    phone: orderForm.value.phone,
    price: orderForm.value.price,
    create_time: new Date().toISOString().slice(0,10),
    config: orderForm.value.config
  }
  orders.value.push(newOrder)
  showOrderForm.value = false
  // 清空表单
  orderForm.value = { order_no: '', phone: '', username: '', price: '', config: null }
}

function editOrder(order) {
  orderForm.value = { ...order, username: getUsername(order.phone), config: null }
  showOrderForm.value = true
}

function deleteOrder(order) {
  if (confirm('确认删除该订单？')) {
    // 删除订单
    orders.value = orders.value.filter(o => o.id !== order.id)
    // 检查用户是否还有其他订单
    const user = users.value.find(u => u.phone === order.phone)
    if (user) {
      user.orders = user.orders.filter(no => no !== order.order_no)
      if (user.orders.length === 0) {
        users.value = users.value.filter(u => u.phone !== order.phone)
      }
    }
  }
}

function editGallery(item) {
  galleryForm.value = { ...item }
  showGalleryForm.value = true
}

function saveGallery() {
  showGalleryForm.value = false
}

function deleteGallery(item) {
  if (confirm('确认删除该作品？')) {
    // TODO: 删除作品逻辑
  }
}

function logout() {
  window.location.reload()
}

</script>

<style scoped>
.admin-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 12px;
}
.admin-table-section {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(52,152,219,0.08);
  padding: 18px 12px;
  margin-bottom: 18px;
}
.admin-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 12px;
}
.admin-table th, .admin-table td {
  border-bottom: 1px solid #eee;
  padding: 8px 6px;
  text-align: center;
  font-size: 15px;
}
.admin-table th {
  background: #f4f4f4;
  color: #3498db;
}
.admin-btn {
  background: #3498db;
  color: #fff;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  padding: 6px 16px;
  cursor: pointer;
  margin-right: 6px;
  transition: background 0.2s;
}
.admin-btn:hover {
  background: #e67e22;
}
.admin-btn-danger {
  background: #c0392b;
}
.gallery-thumb {
  width: 48px;
  height: 48px;
  object-fit: cover;
  border-radius: 6px;
}
.admin-modal-bg {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(52,152,219,0.12);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}
.admin-modal {
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
.admin-modal h4 {
  color: #3498db;
  margin-bottom: 18px;
}
.admin-modal input {
  width: 220px;
  padding: 8px;
  border-radius: 6px;
  border: 1px solid #e0e0e0;
  font-size: 15px;
  margin-bottom: 12px;
}
@media (max-width: 900px) {
  .admin-content {
    max-width: 98vw;
    padding: 0 2vw;
  }
  .admin-table-section {
    padding: 10px 4px;
    border-radius: 8px;
  }
}
@media (max-width: 600px) {
  .admin-navbar {
    flex-direction: column;
    gap: 8px;
    padding: 10px 8px;
    border-radius: 0 0 10px 10px;
  }
  .admin-content {
    max-width: 99vw;
    padding: 0 1vw;
  }
  .admin-table-section {
    padding: 6px 2px;
    border-radius: 6px;
  }
  .admin-modal {
    padding: 12px 4vw 12px 4vw;
    min-width: 180px;
  }
  .admin-modal input {
    width: 98vw;
    max-width: 220px;
  }
}
</style>
