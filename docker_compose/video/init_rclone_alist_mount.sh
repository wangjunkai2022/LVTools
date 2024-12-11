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


# 设置要检查的挂载点
# MOUNT_POINT="/path/to/your/mount"

# 检查是否已挂载
if mountpoint -q "$MOUNT_POINT"; then
    echo "正在取消挂载 $MOUNT_POINT ..."
    
    # 取消挂载 rclone
    fusermount -u "$MOUNT_POINT" || umount "$MOUNT_POINT"
    
    if [ $? -eq 0 ]; then
        echo "成功取消挂载 $MOUNT_POINT."
    else
        echo "取消挂载 $MOUNT_POINT 失败，请检查是否有其他进程占用该目录."
    fi
else
    echo "$MOUNT_POINT 并未挂载."
fi

rclone mount alist_webdav:/ ${MOUNT_POINT} \
    --cache-dir /cache \
    --allow-other \
    --allow-root \
    --allow-non-empty \
    --file-perms 0777 \
    --multi-thread-streams 1024 \
    --multi-thread-cutoff 128M \
    --network-mode \
    --vfs-cache-mode full \
    --vfs-cache-max-size 100G \
    --vfs-cache-max-age 12h \
    --buffer-size 64K \
    --vfs-read-chunk-size 1M \
    --vfs-read-chunk-size-limit 50M \
    --no-modtime \
    --no-checksum \
    --vfs-read-wait 0ms \
    -v \
    --ignore-size \
    --log-file /config/log/log.txt