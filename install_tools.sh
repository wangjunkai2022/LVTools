#!/bin/bash
# 安装docker和所有工具到服务器
cd ~
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wangjunkai2022/LVTools/master/install_tools.sh)"
function docker_install() {
  echo "检查Docker......"
  docker -v
  if [ $? -eq 0 ]; then
    echo "检查到Docker已安装!"
  else
    echo "安装docker环境..."
    sudo apt update
    sudo apt install davfs2 -y
    sudo apt install docker.io -y
    echo "安装docker环境...安装完成!"
    echo "开始重启电脑"
    sudo reboot
  fi
}
docker_install

echo "开始安装Video需要的docker插件"

docker pull linuxserver/prowlarr
docker pull linuxserver/sonarr
docker pull linuxserver/radarr
docker pull p3terx/aria2-pro
docker pull emby/embyserver
docker pull portainer/portainer-ce
docker pull linuxserver/ombi
docker pull allanpk716/chinesesubfinder
docker pull linuxserver/bazarr
docker pull xhofe/alist

docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce

mkdir -p ~/videos/data/电影
mkdir -p ~/videos/data/电视
mkdir -p ~/videos/data/下载

mkdir -p ~/videos/tools/prowlarr
docker run -d --name=prowlarr -p 9696:9696 -v ~/videos/tools/prowlarr:/config --restart always linuxserver/prowlarr

mkdir -p ~/videos/tools/sonarr
docker run -d --name=sonarr -p 8989:8989 -v ~/videos/tools/sonarr:/config -v ~/videos/data/电视:/media/电视 -v ~/videos/data/下载:/mnt/下载 --restart always linuxserver/sonarr

mkdir -p ~/videos/tools/radarr
docker run -d --name=radarr -p 7878:7878 -v ~/videos/tools/radarr:/config -v ~/videos/data/电影:/media/电影 -v ~/videos/data/下载:/mnt/下载 --restart always linuxserver/radarr

mkdir -p ~/videos/tools/aria2
docker run -d --name aria2-pro --restart always --log-opt max-size=1m -e RPC_PORT=6800 -p 6800:6800 -p 6888:6888 -p 6888:6888/udp -v ~/videos/tools/aria2:/config -v ~/videos/data/下载:/downloads p3terx/aria2-pro

mkdir -p ~/videos/tools/embyserver
docker run -d --name embyserver -v ~/videos/tools/embyserver:/config -v ~/videos/data/电视:/media/电视 -v ~/videos/data/电影:/media/电影 -p 8096:8096 -p 8920:8920 --restart always emby/embyserver

mkdir -p ~/videos/tools/ombi
docker run -d --name=ombi -e BASE_URL=/ombi -p 3579:3579 -v ~/videos/tools/ombi:/config --restart always linuxserver/ombi

mkdir -p ~/videos/tools/chinesesubfinder/config
mkdir -p ~/videos/tools/chinesesubfinder/browser
docker run -d --name chinesesubfinder -v ~/videos/tools/chinesesubfinder/config:/config -v ~/videos/data/电影:/media/电影 -v ~/videos/data/电视:/media/电视 -v ~/videos/tools/chinesesubfinder/browser:/root/.cache/rod/browser -p 19035:19035 -p 19037:19037 --log-driver "json-file" --log-opt "max-size=10m" --restart=always allanpk716/chinesesubfinder

mkdir -p ~/videos/tools/bazarr
docker run -d --name=bazarr -p 6767:6767 -v ~/videos/tools/bazarr:/config -v ~/videos/data/电影:/media/电影 -v ~/videos/data/电视:/media/电视 --restart always linuxserver/bazarr

mkdir -p ~/videos/tools/alist
docker run -d --restart=always -v ~/videos/tools/alist:/opt/alist/data -p 5244:5244 --name="alist" xhofe/alist
