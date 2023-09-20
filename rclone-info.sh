#!/bin/bash

docker pull rclone/rclone
#下面这句话不知道有什么用现在
#docker volume create rclonevolume -d rclone -o type=sftp -o sftp-host=_hostname_ -o sftp-user=_username_ -o sftp-pass=_password_ -o allow-other=true

#运行前需要先 创建一个 名字为 alist_webdav 的webdav 服务
#创建rclone的配置文件
docker run -it --rm --name rclone_temp -v /data/videos/tools/rclone/config:/config/rclone rclone/rclone config

# alist_webdav
# url :http://ip:5244:/dav
# admin
# 密码


#查看是否生成了 alist_webdav 的配置
docker run -it --rm --name rclone_temp -v /data/videos/tools/rclone/config:/config/rclone rclone/rclone listremotes
#把 alist_webdav 挂载到硬盘 /data/videos/media/alist 中
docker run -d --name rclone-alist -v /etc/passwd:/etc/passwd:ro -v /etc/group:/etc/group:ro -v /data/videos/tools/rclone/config:/config/rclone -v /data/videos/media/alist:/data:shared -v /data/videos/tools/rclone/cache:/cache --device /dev/fuse:/dev/fuse --cap-add SYS_ADMIN --security-opt apparmor:unconfined --restart always rclone/rclone mount alist_webdav:/ /data --cache-dir /cache --allow-other --vfs-cache-mode writes --allow-non-empty --vfs-cache-max-size=50G --vfs-cache-max-age=12h
