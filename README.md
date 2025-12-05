# Gemini API Nginx Proxy on Render

这是一个用于在 Render 上部署 Nginx 反向代理的项目，主要用于中转 Google Gemini API (`generativelanguage.googleapis.com`) 的流量。
## 特性
- **极简部署**: 只需要一个 Dockerfile 和一个 Nginx 配置。
- **流式支持**: 针对 Gemini 的 Stream 模式进行了优化，关闭了 Nginx 缓冲。
- **SSL 穿透**: 正确处理 SNI 和 Host 头，确保能连接到 Google 服务器。

## 部署步骤
### 1. 准备代码库
你可以直接 Fork 本仓库，或者在你的 GitHub/GitLab 上创建一个新仓库，并上传以下两个文件：
- `Dockerfile`
- `nginx.conf.template`
### 2. 在 Render 上创建服务
1. 注册并登录 [Render.com](https://render.com "null")。
2. 点击右上角的 **New +** 按钮，选择 **Web Service**。
3. 连接你刚才创建的 GitHub/GitLab 仓库。
4. **配置参数**:
    - **Name**: 给你的服务起个名字 (例如: `gemini-proxy`)。
    - **Region**: 建议选择 **Singapore** (新加坡) 或 **Oregon** (美国)，连接 Google 速度较快且通常不被封锁。
    - **Runtime**: 选择 **Docker**。
    - **Instance Type**: 选择 **Free** (免费版足以应付个人使用)。
    - **Environment Variables**: 你可以添加一个名为 `PORT` 的变量，值为 `80`，但通常 Render 会自动处理。
5. 点击 **Create Web Service**。
### 3. 等待部署
Render 会自动拉取代码、构建 Docker 镜像并启动。构建过程可能需要几分钟。
当看到日志显示 `Configuration complete; ready for start up` 时，说明部署成功。
### 4. 测试使用
假设 Render 分配给你的域名是 `https://gemini-proxy.onrender.com`。

**原生 API 地址:** `https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=YOUR_API_KEY`

**你的代理地址:** `https://gemini-proxy.onrender.com/v1beta/models/gemini-pro:generateContent?key=YOUR_API_KEY`

现在，你可以将你的代理地址填入任何支持 Gemini 的客户端（如 NextChat, Chatbox, 或 Python 脚本）中的 "Base URL" 或 "API Endpoint" 字段。

**注意**: 在某些客户端中，Base URL 只需要填 `https://gemini-proxy.onrender.com`，客户端会自动拼接后面的路径。

## 常见问题

**Q: 为什么生成的回复是一次性出来的，没有打字机效果？** A: 请检查客户端是否开启了 Stream 模式。本代理已配置 `proxy_buffering off;`，理论上支持流式传输。

**Q: Render 免费版会休眠吗？** A: 会。如果 15 分钟没有流量，服务会休眠。下次请求时会有 30-50 秒的启动延迟。你可以使用 UptimeRobot 等工具每隔 10 分钟 ping 一次你的 `/health` 端点来保持唤醒。
