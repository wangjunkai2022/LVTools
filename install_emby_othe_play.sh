#!/bin/bash
# 安装 embyserver web 第三方应用打开
cd $(dirname $0)
echo -e 'git 在大陆无法连接网络 请输入http代理 \n不需要输入"http://"直接输入ip:p和端口即可。。\n如: "192.168.50.2:10809" \n如果不用则直接输入回车'
read proxy_ip
if [ -z "$proxy_ip" ]; then
  echo "不走代理下载"
  cp emby_docker_install_webExPlayer.sh emby_docker_install_webExPlayer_temp.sh
else
  echo "代理为:$proxy_ip"
  sed "2i\export http_proxy=http://$proxy_ip \nexport https_proxy=http://$proxy_ip" emby_docker_install_webExPlayer.sh >emby_docker_install_webExPlayer_temp.sh
  # 容器的wget无法使用-e的代理命令
  #  sed '7i\  wget -e "https_proxy=http://$proxy_ip" https://github.com/bpking1/embyExternalUrl/archive/refs/tags/v0.0.6.zip' emby_docker_install_webExPlayer.sh >emby_docker_install_webExPlayer_temp.sh
fi
echo "正在复制添加脚本文件到embyserver容器中"
docker cp emby_docker_install_webExPlayer_temp.sh embyserver:/
echo "正在运行添加脚本文件"
docker exec embyserver sh emby_docker_install_webExPlayer_temp.sh
rm emby_docker_install_webExPlayer_temp.sh
echo "完成"
echo "正重启embyserver容器中"
docker restart embyserver
