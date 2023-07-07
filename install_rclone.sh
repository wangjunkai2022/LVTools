#!/bin/bash
cd ~
function rclone_install() {
  echo "检查rclone......"
  rclone version
  if [ $? -eq 0 ]; then
    echo "检查到rclone已安装!"
  else
    echo "安装rclone环境..."
    sudo apt install rclone -y
    echo "安装rclone环境...安装完成!"
  fi
}
rclone_install
if [ ! -d ~/videos/media/movie/alist ]; then
  echo "文件不存在"
  mkdir -p ~/videos/media/movie/alist
else
  echo "文件存在"
fi
rclone mount alist: ~/videos/media/movie/alist --umask 0000 --default-permissions --allow-non-empty --allow-other --buffer-size 32M --dir-cache-time 12h --vfs-read-chunk-size 64M --vfs-read-chunk-size-limit 1G --vfs-cache-mode full --file-perms 0777 --dir-perms 0777 --daemon --uid 1000
echo "rclone已经连接 alist 到 ~/videos/media/movie/alist 下"
