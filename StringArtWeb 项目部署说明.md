# StringArtWeb 项目部署说明

## 一、开发端部署流程

### 1. 安装 Node.js 和 npm
- 访问 [Node.js 官网](https://nodejs.org/) 下载并安装 LTS 版本。
- 安装完成后，打开终端（PowerShell），输入 `node -v` 和 `npm -v` 检查版本。

### 2. 安装依赖
在项目根目录下执行：
```powershell
npm install
```

### 3. 本地开发预览
启动开发服务器：
```powershell
npm run dev
```
浏览器访问终端提示的本地地址（如 http://localhost:5173）。

### 4. 构建生产环境文件
执行：
```powershell
npm run build
```
构建后的静态文件会生成在 `dist` 文件夹。

### 5. 自动上传到服务器
可使用如下批处理脚本（需安装 scp 工具）：

```bat
@echo off
call npm run build
if errorlevel 1 (
    echo 构建失败，终止部署！
    pause
    exit /b
)
set SERVER_USER=root
set SERVER_IP=49.235.190.13
set SERVER_PORT=2222
set SERVER_PATH=/var/www/html/StringArtWeb
scp -P %SERVER_PORT% -r dist\* %SERVER_USER%@%SERVER_IP%:%SERVER_PATH%
echo 部署完成！
pause
```

### 6. 部署到 GitHub Pages

#### package.json 推荐写法

```json
{
  "name": "stringartweb",
  "version": "0.0.0",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "deploy": "gh-pages -d dist -r https://github.com/chen-jianwen/StringArtWeb.git"
  },
  "dependencies": {
    "vue": "^3.4.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.0",
    "vite": "^5.0.0",
    "gh-pages": "^6.0.0"
  }
}
```

#### 部署流程

1. 安装 gh-pages 依赖：
   ```powershell
   npm install gh-pages --save-dev
   ```
2. 构建并部署：
   ```powershell
   npm run build
   npm run deploy
   ```
3. 在 GitHub 仓库设置中，将 Pages 发布源设置为 `gh-pages` 分支。
4. 稍后可通过 `https://你的用户名.github.io/你的仓库名/` 访问你的项目。

---

## 二、服务端部署流程

### 1. 安装 Nginx（Ubuntu 示例）
```bash
sudo apt update
sudo apt install nginx -y
```

### 2. 创建部署目录
```bash
sudo mkdir -p /var/www/html/StringArtWeb
```

### 3. 设置目录权限
```bash
sudo chown -R www-data:www-data /var/www/html/StringArtWeb
sudo chmod -R 755 /var/www/html/StringArtWeb
```

### 4. 配置 Nginx
编辑 `/etc/nginx/conf.d/stringartweb.conf`，内容如下：

```nginx
server {
    listen 80;
    server_name 49.235.190.13;

    root /var/www/html;

    location /StringArtWeb/ {
        try_files $uri $uri/ /StringArtWeb/index.html;
    }
}
```

### 5. 检查并重启 Nginx
```bash
sudo nginx -t
sudo systemctl restart nginx
```

### 6. 验证部署
浏览器访问 `http://49.235.190.13/StringArtWeb/`，确认页面正常显示。

---

## 常见问题排查

- **页面空白或资源 404**：检查 `vite.config.js` 的 `base` 是否为 `/StringArtWeb/`，并确认所有静态资源已上传到服务器对应目录。
- **500 Internal Server Error**：检查 Nginx 配置语法和文件权限，查看 `/var/log/nginx/error.log` 获取详细错误信息。
- **端口无法访问**：确认服务器防火墙和云平台安全组已开放 80 端口。
- **GitHub Pages 访问空白**：确认 `vite.config.js` 的 `base` 与仓库名一致，且已正确推送到 `gh-pages` 分支。

---

如有其他问题，请参考本项目文档或联系开发者。