#!/bin/sh

# 设置要检查的挂载点
# MOUNT_POINT="/path/to/your/mount"

# 检查是否已挂载
if mountpoint -q "$MOUNT_POINT"; then
    echo "rclone 已挂载到 $MOUNT_POINT."
    exit 0
else
    echo "rclone 并未挂载到 $MOUNT_POINT."
    exit 1
fi