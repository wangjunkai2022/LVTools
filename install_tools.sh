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

uid=1000
#gid=1000
echo "开始安装Video需要的docker插件"

docker pull linuxserver/prowlarr:latest
docker pull linuxserver/sonarr:latest
docker pull linuxserver/radarr:latest
docker pull p3terx/aria2-pro
docker pull emby/embyserver:latest
docker pull portainer/portainer-ce
docker pull linuxserver/ombi:latest
docker pull allanpk716/chinesesubfinder:latest
docker pull linuxserver/bazarr:latest
docker pull xhofe/alist
docker pull linuxserver/jackett

docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce

mkdir -p ~/videos/media/movie
mkdir -p ~/videos/media/series
mkdir -p ~/videos/downloads

mkdir -p ~/videos/tools/prowlarr
docker run -d --name=prowlarr -p 9696:9696 -v ~/videos/tools/prowlarr:/config --restart always linuxserver/prowlarr

mkdir -p ~/videos/tools/sonarr
docker run -d --name=sonarr -e uid=$uid -p 8989:8989 -v ~/videos/tools/sonarr:/config -v ~/videos/media:/media -v ~/videos/downloads:/mnt/downloads --restart always linuxserver/sonarr

mkdir -p ~/videos/tools/radarr
docker run -d --name=radarr -e uid=$uid -p 7878:7878 -v ~/videos/tools/radarr:/config -v ~/videos/media:/media -v ~/videos/downloads:/mnt/downloads --restart always linuxserver/radarr

mkdir -p ~/videos/tools/aria2
docker run -d --name aria2-pro -e uid=$uid --restart always --log-opt max-size=1m -e RPC_PORT=6800 -p 6800:6800 -p 6888:6888 -p 6888:6888/udp -v ~/videos/tools/aria2:/config -v ~/videos/downloads:/downloads p3terx/aria2-pro

mkdir -p ~/videos/tools/embyserver
docker run -d --name embyserver -e uid=$uid -v ~/videos/tools/embyserver:/config -v ~/videos/media:/media -p 8096:8096 -p 8920:8920 --restart always emby/embyserver

mkdir -p ~/videos/tools/ombi
docker run -d --name=ombi -e BASE_URL=/ombi -p 3579:3579 -v ~/videos/tools/ombi:/config --restart always linuxserver/ombi

mkdir -p ~/videos/tools/chinesesubfinder/config
mkdir -p ~/videos/tools/chinesesubfinder/browser
docker run -d --name chinesesubfinder -v -e uid=$uid ~/videos/tools/chinesesubfinder/config:/config -v ~/videos/media:/media -v ~/videos/tools/chinesesubfinder/browser:/root/.cache/rod/browser -p 19035:19035 -p 19037:19037 --log-driver "json-file" --log-opt "max-size=10m" --restart=always allanpk716/chinesesubfinder

mkdir -p ~/videos/tools/bazarr
docker run -d --name=bazarr -e uid=$uid -p 6767:6767 -v ~/videos/tools/bazarr:/config -v ~/videos/media:/media --restart always linuxserver/bazarr

mkdir -p ~/videos/tools/alist
docker run -d --restart=always -v ~/videos/tools/alist:/opt/alist/data -p 5244:5244 --name="alist" xhofe/alist

mkdir -p ~/videos/tools/jackett
docker run -d --name=jackett --restart=always -e uid=$uid -v ~/videos/tools/jackett:/config -p 9117:9117 linuxserver/jackett