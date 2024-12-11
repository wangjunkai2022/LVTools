#!/bin/sh

# 定义要检查的远程配置名称
# REMOTE_NAME="alist_webdav"

function init_conf(){
    echo "初始化 rclone"
#     # 检查 rclone 的配置文件路径
#     CONFIG_FILE="/config/rclone/rclone.conf"

#     # 检查是否存在 alist_webdav 配置
#     if ! grep -q "alist_webdav" "$CONFIG_FILE"; then
#         echo "Creating rclone configuration for alist_webdav..."

#         # 添加 alist_webdav 配置（请根据实际需要调整参数）
#     cat <<EOL >> "$CONFIG_FILE"
# [alist_webdav]
# type = webdav
# url = http://alist:5244/dav
# vendor = other
# user = guest  # 替换为你的用户名
# pass = qsDWbInzy1zmqR9uMlCWLGOCSMLz   # 替换为你的密码（如果有）
# EOL

#         echo "Configuration for alist_webdav created."
#     else
#         echo "alist_webdav configuration already exists."
#     fi

    # 检查 rclone 配置中是否存在该远程
    if rclone listremotes | grep -q "$REMOTE_NAME"; then
        echo "远程配置 '$REMOTE_NAME' 已存在。"
    else
        # 如果不存在，则创建新的 WebDAV 配置
        echo "远程配置 '$REMOTE_NAME' 不存在，正在创建..."
        rclone config create "$REMOTE_NAME" webdav url=http://alist:5244/dav user=admin pass=${ALIST_PASSWORD}
        if [ $? -eq 0 ]; then
            echo "远程配置 '$REMOTE_NAME' 创建成功！"
        else
            echo "远程配置 '$REMOTE_NAME' 创建失败！"
        fi
    fi
}

# 判断是否能连接成功
function check_content(){
    echo 判断${REMOTE_NAME}是否配置能连接成功
    rclone lsd ${REMOTE_NAME}:/
    return $?
}

# 每 60 秒执行一次检测 check_content 的返回值是否是 0
function wait_conten_ok(){
    while true; do
        # 调用 check_content 函数
        check_content
        # 获取 check_content 的返回值
        if [ $? -eq 0 ]; then
            echo "连接成功，退出循环"
            break  # 返回值为 0，表示连接成功，退出循环
        else
            echo "连接失败，等待 10 秒后重试"
            sleep 10  # 如果连接失败，等待 10 秒后重试
        fi
    done
}

# 设置要检查的挂载点
# MOUNT_POINT="/path/to/your/mount"

# 检查是否已挂载
function unmount_rclone(){
    mountpoint "$MOUNT_POINT"
    if [ $? -eq 0 ]; then
        echo "正在取消挂载 $MOUNT_POINT ..."
        # 取消挂载 rclone
        fusermount3 -zu "$MOUNT_POINT"
        if [ $? -eq 0 ]; then
            echo "成功取消挂载 $MOUNT_POINT."
        else
            echo "取消挂载 $MOUNT_POINT 失败，请检查是否有其他进程占用该目录."
        fi
    else
        echo "$MOUNT_POINT 并未挂载."
    fi
}
function mount_rclone(){
    echo 开始挂载${REMOTE_NAME}到路径${MOUNT_POINT}下
    rclone mount ${REMOTE_NAME}:/ ${MOUNT_POINT} \
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

    if [ $? -eq 0 ]; then
        echo "挂载到$MOUNT_POINT 成功..."
        while true; do
            sleep 999999
        fi
    done
    else
        echo "挂载到$MOUNT_POINT 失败..."
        unmount_rclone
        echo "等待120秒重新挂载"
        sleep 120
        mount_rclone
    fi
}
init_conf
wait_conten_ok
# unmount_rclone
mount_rclone