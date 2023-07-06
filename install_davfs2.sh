#!/bin/bash
cd ~
#function davfs2_install() {
#  echo "检查davfs2......"
#  docker -v
#  if [ $? -eq 0 ]; then
#    echo "检查到davfs2已安装!"
#  else
#    echo "安装davfs2环境..."
#    sudo apt install davfs2 -y
#    echo "安装davfs2环境...安装完成!"
#  fi
#}
#davfs2_install
function echo_green() {
  echo -e "\033[32m$1\033[0m"
}
echo_green "是否一键连接alist到video中?(y/n)"
read answer
if [ "$answer" == "y" ]; then
  ips=$(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')
  echo "这是获取到的ip"
  echo $ips
  echo_green "请输入IP 或者 直接默认（只有一个时才用默认）"
  read input_str
  if [ "$input_str" != "" ]; then
    ips=$input_str
  fi
  echo "确定的ip是$ips"
  echo "ignore_dav_header 1" | sudo tee --append /etc/davfs2/davfs2.conf
  echo "use_locks       0" | sudo tee --append /etc/davfs2/davfs2.conf

  echo "http://$ips:5244/dav/ /mnt/alist/ davfs rw,user,file_mode=0777,dir_mode=0777,_netdev 0 0" | sudo tee --append /etc/fstab
fi
