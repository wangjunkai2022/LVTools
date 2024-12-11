#!/bin/sh

# 设置要检查的挂载点
# MOUNT_POINT="/path/to/your/mount"

# 检查是否已挂载
# if mountpoint -q "$MOUNT_POINT"; then
#     echo "rclone 已挂载到 $MOUNT_POINT."
#     exit 0
# else
#     echo "rclone 并未挂载到 $MOUNT_POINT."
#     exit 1
# fi


# 获取文件夹下的文件个数
FILE_COUNT=$(find "$MOUNT_POINT" -maxdepth 0 -type d | wc -l)
# 检查文件个数是否大于 0
if [ "$FILE_COUNT" -gt 0 ]; then
    exit 0
else
    exit 1
fi