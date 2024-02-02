#!/bin/bash

docker pull rclone/rclone
#下面这句话不知道有什么用现在
#docker volume create rclonevolume -d rclone -o type=sftp -o sftp-host=_hostname_ -o sftp-user=_username_ -o sftp-pass=_password_ -o allow-other=true
workdir=$(
  cd $(dirname $0)
  pwd
)

config_root_path=$workdir/rclone
alist_root_path=$workdir/rclone/data
echo "是否生成配置文件(y/生成 c/复制已有的文件自己修改)"
read answer
if [ "$answer" == "y" ]; then
  #运行前需要先 创建一个 名字为 alist_webdav 的webdav 服务
  #创建rclone的配置文件
  echo '开始创建 rclone 配置文件'
  echo "安装这个步骤开始输入"
  echo "No remotes found, make a new one?"
  echo "输入 n"
  echo
  echo "Enter name for new remote."
  echo "输入"
  echo "alist_webdav"
  echo
  echo 'Choose a number from below, or type in your own value.'
  echo '查找 WebDAV 并输入编号'
  echo '现在的编号：
  49 / WebDAV
   \ (webdav)
  50 / Yandex Disk
   \ (yandex)
  所以输入49
   '
  echo
  echo "url 输入alist的地址 如："
  echo 'http://192.168.50.2:5244/dav'
  echo
  echo "Press Enter to leave empty."
  echo "输入 Other site/service or software 的编号"
  echo
  echo "user"
  echo "输入alist的登陆用户名 如："
  echo "admin"
  echo
  echo "Choose an alternative below. Press Enter for the default (n)."
  echo -e "这里输入y\n需要填写密码\n也就是alist admin的密码\n 需要输入2次"
  echo
  echo "后面直接一路跳过 一直输入回车 直到："
  echo "Edit existing remote"
  echo "输入q"

# alist_webdav
# url :http://ip:5244/dav
# admin
# 密码
elif [ "$answer" == "c" ]; then
  mkdir -p -m 777 $config_root_path/config/
  cp $(
    cd "$(dirname "$0")"
    pwd
  )/rclone/rclone.conf $config_root_path/config/

  echo "更具需要修改配置文件"
fi
docker run -it --rm --name rclone_temp -v $config_root_path/config:/config/rclone rclone/rclone config

#查看是否生成了 alist_webdav 的配置
docker run -it --rm --name rclone_temp -v $config_root_path/config:/config/rclone rclone/rclone listremotes

#把 alist_webdav 挂载到硬盘 /data/videos/media/alist 中
docker run -d --name rclone-alist \
  -v /etc/passwd:/etc/passwd:ro \
  -v /etc/group:/etc/group:ro \
  -v $config_root_path/config:/config/rclone \
  -v $config_root_path/log:/config/log \
  -v $alist_root_path:/data:shared \
  -v $config_root_path/cache:/cache \
  --device /dev/fuse:/dev/fuse \
  --cap-add SYS_ADMIN \
  --security-opt apparmor:unconfined \
  --restart always \
  rclone/rclone \
  mount alist_webdav:/ /data \
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

# emby 人家的配置
#--allow-non-empty --no-gzip-encoding  --umask 000 --allow-other --attr-timeout 10m --vfs-cache-mode full --vfs-cache-max-age 1m --vfs-read-chunk-size-limit 100M --buffer-size 100M --vfs-cache-max-size 10G --daemon

#https://github.com/cgkings/script-store

# 扫库
# rclone mount alist_webdav:/ /mnt/alist --cache-dir=/tmp/alist_cache --use-mmap --umask 000 --allow-other --allow-non-empty --dir-cache-time 24h --vfs-cache-mode full --vfs-read-chunk-size 1M --vfs-read-chunk-size-limit 16M --checkers=4 --transfers=1 --vfs-cache-max-size 10G

#观看
# rclone mount alist_webdav:/ /mnt/alist --cache-dir=/tmp/alist_cache --use-mmap --umask 000 --allow-other --allow-non-empty --dir-cache-time 24h --vfs-cache-mode full --buffer-size 512M --vfs-read-chunk-size 16M --vfs-read-chunk-size-limit 64M --checkers=4 --transfers=1 --vfs-cache-max-size 10G
