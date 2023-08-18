#!/bin/bash
echo -e "安装 cloudflare"

echo -e "请输入主域名"
read dns
echo -e "输入的域名是：$dns"
echo -e "请输入cloudflare api key"
read key
echo -e "输入的key是：$key"

docker pull oznu/cloudflare-ddns
# 检查容器是否存在 glances 系统监控
name="cloudflare-ddns-home"
container=$(docker ps -q -f name=$name)
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 $name ..."
  docker run -d --name $name -d --net=host --restart="always" -e API_KEY=$key -e ZONE=$dns -e SUBDOMAIN=home -e PROXIED=true -e RRTYPE=AAAA oznu/cloudflare-ddns
else
  echo "$name 容器已存在 不用创建"
fi

# 检查容器是否存在 glances 系统监控
name="cloudflare-ddns-emby"
container=$(docker ps -q -f name=$name)
if [ -z "$container" ]; then
  echo "容器不存在，正在创建容器 $name ..."
  docker run -d --name $name -d --net=host --restart="always" -e API_KEY=$key -e ZONE=$dns -e SUBDOMAIN=emby -e PROXIED=true -e RRTYPE=AAAA oznu/cloudflare-ddns
else
  echo "$name 容器已存在 不用创建"
fi