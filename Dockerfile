# 使用基于 Alpine 的轻量级 Nginx 镜像
FROM nginx:alpine

# 设置默认端口环境变量 (Render 会自动覆盖这个值，但设置默认值是好习惯)
ENV PORT=80

# 将自定义的 Nginx 配置模板复制到镜像中的模板目录
# Nginx 官方镜像启动时会自动读取 templates 目录下的 .template 文件
# 并使用 envsubst 替换环境变量后输出到 /etc/nginx/conf.d/default.conf
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

# 暴露端口 (仅用于文档说明，实际由 Render 动态决定)
EXPOSE ${PORT}

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
