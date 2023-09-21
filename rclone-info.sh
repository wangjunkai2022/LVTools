#!/bin/bash

docker pull rclone/rclone
#下面这句话不知道有什么用现在
#docker volume create rclonevolume -d rclone -o type=sftp -o sftp-host=_hostname_ -o sftp-user=_username_ -o sftp-pass=_password_ -o allow-other=true

#运行前需要先 创建一个 名字为 alist_webdav 的webdav 服务
#创建rclone的配置文件
docker run -it --rm --name rclone_temp -v /data/videos/tools/rclone/config:/config/rclone rclone/rclone config

# alist_webdav
# url :http://ip:5244/dav
# admin
# 密码


#查看是否生成了 alist_webdav 的配置
docker run -it --rm --name rclone_temp -v /data/videos/tools/rclone/config:/config/rclone rclone/rclone listremotes
#把 alist_webdav 挂载到硬盘 /data/videos/media/alist 中
docker run -d --name rclone-alist -v /etc/passwd:/etc/passwd:ro -v /etc/group:/etc/group:ro -v /data/videos/tools/rclone/config:/config/rclone -v /data/videos/media/alist:/data:shared -v /data/videos/tools/rclone/cache:/cache --device /dev/fuse:/dev/fuse --cap-add SYS_ADMIN --security-opt apparmor:unconfined --restart always rclone/rclone mount alist_webdav:/ /data --cache-dir /cache --allow-other --allow-non-empty --multi-thread-streams 1024 --multi-thread-cutoff 128M --network-mode --vfs-cache-mode full --vfs-cache-max-size 100G --vfs-cache-max-age 2h --vfs-read-chunk-size-limit off --buffer-size 64K --vfs-read-chunk-size 64K --vfs-read-wait 0ms -v --vfs-read-chunk-size-limit 64K --vfs-read-wait 0ms



#--multi-thread-streams 1024 --multi-thread-cutoff 128M --network-mode --vfs-cache-mode full --vfs-cache-max-size 100G --vfs-cache-max-age 240000h --vfs-read-chunk-size-limit off --buffer-size 64K --vfs-read-chunk-size 64K --vfs-read-wait 0ms -v --vfs-read-chunk-size-limit 64K --vfs-read-wait 0ms -v -vv

#–cache-dir：缓慢目录
#
#–multi-thread-streams ：下载的线程数
#
#–multi-thread-cutoff ：当下载文件到本地后端超过这个大小时，rclone会使用多线程下载文件
#
#–network-mode：网络模式
#
#–vfs-cache-mode ：缓存模式
#
#–vfs-cache-max-size ：缓存大小
#
#–vfs-cache-max-age ：缓存最大时间
#
#–vfs-read-chunk-size-limit ：关闭块读取大小限制
#
#–buffer-size ：缓冲区
#
#–vfs-read-chunk-size ： vfs块读取大小
#
#–vfs-read-wait 0ms ：块读取等待时间
#
#–vfs-read-chunk-size-limit ：块读取大小限制
#
#–daemon：指后台方式运行 