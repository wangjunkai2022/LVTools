#!/bin/sh

# 检查 rclone 的配置文件路径
CONFIG_FILE="/config/rclone/rclone.conf"

# 检查是否存在 alist_webdav 配置
if ! grep -q "alist_webdav" "$CONFIG_FILE"; then
    echo "Creating rclone configuration for alist_webdav..."

    # 添加 alist_webdav 配置（请根据实际需要调整参数）
    cat <<EOL >> "$CONFIG_FILE"
[alist_webdav]
type = webdav
url = http://alist:5244/webdav
vendor = other
user = guest  # 替换为你的用户名
pass = qsDWbInzy1zmqR9uMlCWLGOCSMLz   # 替换为你的密码（如果有）
EOL

    echo "Configuration for alist_webdav created."
else
    echo "alist_webdav configuration already exists."
fi
