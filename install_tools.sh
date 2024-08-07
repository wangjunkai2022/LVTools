#!/bin/bash
# 安装docker和所有工具到服务器
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

mkdir -p -m 777 /data/videos/tools/ombi
echo -e "Ombi 和 emby 在大陆无法连接网络 请输入代理。。 \n直接输入代理地址和端口 \n如果不用则直接输入回车"
read proxy_ip

uid=0 #使用root的身份 防止有些没有权限
gid=0
echo "开始安装Video需要的docker插件"

mkdir -p -m 777 /data/videos/media/movie/大陆
mkdir -p -m 777 /data/videos/media/movie/香港
mkdir -p -m 777 /data/videos/media/movie/台湾
mkdir -p -m 777 /data/videos/media/movie/日本
mkdir -p -m 777 /data/videos/media/movie/韩国
mkdir -p -m 777 /data/videos/media/movie/东南亚
mkdir -p -m 777 /data/videos/media/movie/欧美
mkdir -p -m 777 /data/videos/media/movie/其他地区

mkdir -p -m 777 /data/videos/media/series/大陆
mkdir -p -m 777 /data/videos/media/series/香港
mkdir -p -m 777 /data/videos/media/series/台湾
mkdir -p -m 777 /data/videos/media/series/日本
mkdir -p -m 777 /data/videos/media/series/韩国
mkdir -p -m 777 /data/videos/media/series/东南亚
mkdir -p -m 777 /data/videos/media/series/欧美
mkdir -p -m 777 /data/videos/media/series/其他地区
mkdir -p -m 777 /data/videos/media/downloads

# 检查容器是否存在 prowlarr
if [ "$1" == "prowlarr" ]; then
  docker stop prowlarr
  docker rm prowlarr
fi
container=$(docker ps -q -f name="prowlarr")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 prowlarr ..."
  docker pull linuxserver/prowlarr:latest
  mkdir -p -m 777 /data/videos/tools/prowlarr
  docker run -d --name=prowlarr \
    -e PUID=$uid -e PGID=$gid \
    -p 9696:9696 \
    -v /data/videos/tools/prowlarr:/config \
    --restart always \
    linuxserver/prowlarr
else
  echo "prowlarr 容器已存在 不用创建"
fi

# 检查容器是否存在 portainer
if [ "$1" == "portainer" ]; then
  docker stop portainer
  docker rm portainer
fi
container=$(docker ps -q -f name="portainer")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 portainer ..."
  docker pull portainer/portainer-ce
  docker run -d \
    -p 9000:9000 \
    --name=portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    portainer/portainer-ce
else
  echo "portainer 容器已存在 不用创建"
fi

# 检查容器是否存在 sonarr
if [ "$1" == "sonarr" ]; then
  docker stop sonarr
  docker rm sonarr
fi
container=$(docker ps -q -f name="sonarr")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 sonarr ..."
  docker pull linuxserver/sonarr:latest
  mkdir -p -m 777 /data/videos/tools/sonarr
  docker run -d \
    --name=sonarr \
    -e PUID=$uid -e PGID=$gid \
    -p 8989:8989 \
    -v /data/videos/tools/sonarr:/config \
    -v /data/videos/media:/media \
    --restart always \
    linuxserver/sonarr
else
  echo "sonarr 容器已存在 不用创建"
fi

# 检查容器是否存在 radarr
if [ "$1" == "radarr" ]; then
  docker stop radarr
  docker rm radarr
fi
container=$(docker ps -q -f name="radarr")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 radarr ..."
  docker pull linuxserver/radarr:latest
  mkdir -p -m 777 /data/videos/tools/radarr
  docker run -d \
    --name=radarr \
    -e PUID=$uid -e PGID=$gid \
    -p 7878:7878 \
    -v /data/videos/tools/radarr:/config \
    -v /data/videos/media:/media \
    --restart always \
    linuxserver/radarr
else
  echo "radarr 容器已存在 不用创建"
fi

# 检查容器是否存在 aria2_pro
if [ "$1" == "aria2_pro" ]; then
  docker stop aria2_pro
  docker rm aria2_pro
fi
container=$(docker ps -q -f name="aria2_pro")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 aria2_pro ..."
  docker pull p3terx/aria2-pro
  mkdir -p -m 777 /data/videos/tools/aria2
  docker run -d \
    --name aria2_pro \
    -e PUID=$uid -e PGID=$gid \
    --restart always \
    --log-opt max-size=1m \
    -e RPC_PORT=6800 \
    -p 6800:6800 \
    -p 6888:6888 \
    -p 6888:6888/udp \
    -v /data/videos/tools/aria2:/config \
    -v /data/videos/media/downloads:/downloads \
    p3terx/aria2-pro

else
  echo "aria2_pro 容器已存在 不用创建"
fi

# 检查容器是否存在 ombi
if [ "$1" == "ombi" ]; then
  docker stop ombi
  docker rm ombi
fi
container=$(docker ps -q -f name="ombi")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 ombi ..."
  docker pull linuxserver/ombi:latest
  mkdir -p -m 777 /data/videos/tools/ombi
  docker run -d \
    --name=ombi \
    -e PUID=$uid \
    -e PGID=$gid \
    --env HTTP_PROXY="$proxy_ip" \
    --env HTTPS_PROXY="$proxy_ip" \
    --env NO_PROXY="127.0.0.1,localhost,192.168.*" \
    -e BASE_URL=/ombi \
    -p 3579:3579 \
    -v /data/videos/tools/ombi:/config \
    --restart always \
    linuxserver/ombi

else
  echo "ombi 容器已存在 不用创建"
fi

# 检查容器是否存在 chinesesubfinder
if [ "$1" == "chinesesubfinder" ]; then
  docker stop chinesesubfinder
  docker rm chinesesubfinder
fi
container=$(docker ps -q -f name="chinesesubfinder")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 chinesesubfinder ..."
  docker pull allanpk716/chinesesubfinder:latest
  mkdir -p -m 777 /data/videos/tools/chinesesubfinder/config
  mkdir -p -m 777 /data/videos/tools/chinesesubfinder/browser
  docker run -d \
    --name chinesesubfinder \
    -e PUID=$uid \
    -e PGID=$gid \
    -v /data/videos/tools/chinesesubfinder/config:/config \
    -v /data/videos/media:/media \
    -v /data/videos/tools/chinesesubfinder/browser:/root/.cache/rod/browser \
    -p 19035:19035 \
    -p 19037:19037 \
    --log-driver "json-file" \
    --log-opt "max-size=10m" \
    --restart=always \
    allanpk716/chinesesubfinder

else
  echo "chinesesubfinder 容器已存在 不用创建"
fi

# 检查容器是否存在 bazarr
if [ "$1" == "bazarr" ]; then
  docker stop bazarr
  docker rm bazarr
fi
container=$(docker ps -q -f name="bazarr")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 bazarr ..."
  docker pull linuxserver/bazarr:latest
  mkdir -p -m 777 /data/videos/tools/bazarr
  docker run -d \
    --name=bazarr \
    -e PUID=$uid \
    -e PGID=$gid \
    -p 6767:6767 \
    -v /data/videos/tools/bazarr:/config \
    -v /data/videos/media:/media \
    --restart always \
    linuxserver/bazarr

else
  echo "bazarr 容器已存在 不用创建"
fi

# 检查容器是否存在 alist
if [ "$1" == "alist" ]; then
  docker stop alist
  docker rm alist
fi
container=$(docker ps -q -f name="alist")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 alist ..."
  docker pull xhofe/alist
  mkdir -p -m 777 /data/videos/tools/alist
  docker run -d \
    --restart=always \
    -e PUID=$uid \
    -e PGID=$gid \
    -v /data/videos/tools/alist:/opt/alist/data \
    -p 5244:5244 \
    --name="alist" \
    xhofe/alist

else
  echo "alist 容器已存在 不用创建"
fi

# 检查容器是否存在 embyserver
if [ "$1" == "embyserver" ]; then
  docker stop embyserver
  docker rm embyserver
fi
container=$(docker ps -q -f name="embyserver")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 embyserver ..."
  #  docker pull emby/embyserver:latest
  #  docker pull linuxserver/emby:latest
  #  docker pull xinjiawei1/emby_unlockd # 解锁版
  # docker pull xiaokai2022/embyserver:latest
  docker pull amilys/embyserve
  #  mkdir -p -m 777 /data/videos/tools/embyserver
  docker run -d \
    --name embyserver \
    --env HTTP_PROXY="$proxy_ip" \
    --env HTTPS_PROXY="$proxy_ip" \
    --env NO_PROXY="127.0.0.1,localhost,192.168.*" \
    --env UID=$uid --env GID=$gid \
    --device /dev/dri:/dev/dri \
    -v /data/videos/tools/embyserver/config:/config \
    -v /data/videos/tools/embyserver/backup:/backup \
    -v /data/videos/media:/media:shared \
    -p 8096:8096 \
    -p 8920:8920 \
    --restart always \
    --pull always \
    amilys/embyserve
#  docker run -d --name embyserver --env HTTP_PROXY="$proxy_ip" --env HTTPS_PROXY="$proxy_ip" --env NO_PROXY="127.0.0.1,localhost,192.168.*" -e PUID=$uid -e PGID=$gid --device /dev/dri:/dev/dri -v /data/videos/tools/embyserver:/config -v /data/videos/media:/media -p 8096:8096 -p 8920:8920 --restart always xinjiawei1/emby_unlockd
else
  echo "embyserver 容器已存在 不用创建"
fi

# 检查容器是否存在 jackett
if [ "$1" == "jackett" ]; then
  docker stop jackett
  docker rm jackett
fi
container=$(docker ps -q -f name="jackett")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 jackett ..."
  docker pull linuxserver/jackett
  mkdir -p -m 777 /data/videos/tools/jackett
  docker run -d \
    --name=jackett \
    --restart=always \
    -e PUID=$uid \
    -e PGID=$gid \
    -v /data/videos/tools/jackett:/config \
    -p 9117:9117 \
    linuxserver/jackett

else
  echo "jackett 容器已存在 不用创建"
fi

# 检查容器是否存在 v2ray ##这个是用来代理的 穿透是另外一个
if [ "$1" == "proxy_v2ray" ]; then
  docker stop proxy_v2ray
  docker rm proxy_v2ray
fi
container=$(docker ps -q -f name="proxy_v2ray")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 proxy_v2ray ..."
  docker pull v2fly/v2fly-core
  mkdir -p -m 777 /data/videos/tools/proxy_v2ray
  docker run -d \
    --name=proxy_v2ray \
    --restart=always \
    -e PUID=$uid \
    -e PGID=$gid \
    -v /data/videos/tools/proxy_v2ray:/config \
    -p 10808:10808 \
    -p 10809:10809 \
    v2fly/v2fly-core \
    run -c /config/config.json
else
  echo "proxy_v2ray 容器已存在 不用创建"
fi

# 检查容器是否存在 v2ray ##这个是用来穿透内网
if [ "$1" == "nat_v2ray" ]; then
  docker stop nat_v2ray
  docker rm nat_v2ray
fi
container=$(docker ps -q -f name="nat_v2ray")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 nat_v2ray ..."
  docker pull v2fly/v2fly-core
  mkdir -p -m 777 /data/videos/tools/nat_v2ray
  docker run -d \
    --name=nat_v2ray \
    --restart=always \
    -e PUID=$uid \
    -e PGID=$gid \
    -v /data/videos/tools/nat_v2ray:/config \
    v2fly/v2fly-core \
    run -c /config/config.json
else
  echo "nat_v2ray 容器已存在 不用创建"
fi

# 检查容器是否存在 qbittorrent
if [ "$1" == "qbittorrent" ]; then
  docker stop qbittorrent
  docker rm qbittorrent
fi
container=$(docker ps -q -f name="qbittorrent")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 qbittorrent ..."
  docker pull linuxserver/qbittorrent
  mkdir -p -m 777 /data/videos/tools/qbittorrent
  docker run -d \
    --name=qbittorrent \
    --restart=always \
    -e PUID=$uid \
    -e WEBUI_PORT=8081 \
    -e PGID=$gid \
    -p 8081:8081 \
    -p 23456:23456 \
    -p 23456:23456/udp \
    -v /data/videos/tools/qbittorrent:/config \
    -v /data/videos/media/downloads:/downloads \
    linuxserver/qbittorrent
else
  echo "qbittorrent 容器已存在 不用创建"
fi

# 检查容器是否存在 qiandao
if [ "$1" == "qiandao" ]; then
  docker stop qiandao
  docker rm qiandao
fi
container=$(docker ps -q -f name="qiandao")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 qiandao ..."
  docker pull a76yyyy/qiandao
  mkdir -p -m 777 /data/videos/tools/qiandao
  docker run -d \
    --name=qiandao \
    --restart=always \
    -p 8923:80 \
    -v /data/videos/tools/qiandao:/usr/src/app/config \
    a76yyyy/qiandao
else
  echo "qiandao 容器已存在 不用创建"
fi

# 检查容器是否存在 flaresolverr 配合一些pt签到使用（代理验证cf）
if [ "$1" == "flaresolverr" ]; then
  docker stop flaresolverr
  docker rm flaresolverr
fi
container=$(docker ps -q -f name="flaresolverr")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 flaresolverr ..."
  docker pull flaresolverr/flaresolverr
  docker run -d \
    --name=flaresolverr \
    --restart=always \
    -p 8191:8191 \
    -e LOG_LEVEL=info \
    -e TZ="Asia/Shanghai" \
    flaresolverr/flaresolverr
else
  echo "flaresolverr 容器已存在 不用创建"
fi

# 检查容器是否存在 nginx
if [ "$1" == "nginx" ]; then
  docker stop nginx
  docker rm nginx
fi
container=$(docker ps -q -f name="nginx")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 nginx ..."
  docker pull xiaokai2022/nginx_webext
  mkdir -p -m 777 /data/videos/tools/
  cp -r $(dirname $0)/nginx /data/videos/tools
  docker run -d \
    --name=nginx \
    -e PUID=$uid \
    --restart=always \
    -p 443:443 \
    -p 80:80 \
    -v /data/videos/tools/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
    -v /data/videos/tools/nginx:/nginx \
    -v /data/videos/media:/media \
    xiaokai2022/nginx_webext
else
  echo "nginx 容器已存在 不用创建"
fi

# 检查容器是否存在 glances 系统监控
if [ "$1" == "glances" ]; then
  docker stop glances
  docker rm glances
fi
container=$(docker ps -q -f name="glances")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 glances ..."
  docker pull nicolargo/glances
  docker run -d \
    --name=glances \
    --restart="always" \
    -p 61208-61209:61208-61209 \
    -e GLANCES_OPT="-w" \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    nicolargo/glances
else
  echo "glances 容器已存在 不用创建"
fi

# 检查容器是否存在 resilio_sync 系统监控
if [ "$1" == "resilio_sync" ]; then
  docker stop resilio_sync
  docker rm resilio_sync
fi
container=$(docker ps -q -f name="resilio_sync")
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 resilio_sync ..."
  docker pull linuxserver/resilio-sync
  mkdir -p -m 777 /data/videos/tools/resilio_sync
  docker run -d \
    --name=resilio_sync \
    --env UID=$uid --env GID=$gid \
    -e TZ=Asia/Chongqing \
    -p 8888:8888 \
    -p 55555:55555 \
    -v /data/videos/tools/resilio_sync/config:/config \
    -v /data/videos/tools/resilio_sync/downloads:/downloads \
    -v /data/videos/media/sync:/sync \
    --restart always \
    linuxserver/resilio-sync

  sleep 3
  cp $(
    cd "$(dirname "$0")"
    pwd
  )/ResilioSyncPro.btskey /data/videos/tools/resilio_sync/config/
else
  echo "resilio_sync 容器已存在 不用创建"
fi
