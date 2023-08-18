#!/bin/bash
echo -e "安装 cloudflare ddns 子域名"
dns=""
dns_ok=1
function docker_install() {
  domain_flag=$(echo "$dns" | gawk '/^(http(s)?:\/\/)?[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+(:[0-9]{1,5})?$/{print $0}')
  if [ ! -n "${domain_flag}" ]; then
    echo "域名有误,请重新输入!!!"
    dns_ok=1
  else
    echo -e "输入的域名是：$dns"
    dns_ok=0
  fi
}

if [ -n "$1" ]; then
  dns=$1
fi

docker_install
while [ $dns_ok == 1 ]; do
  read -p "请输入主域名: " dns
  docker_install
done

if [ -n "$2" ]; then
  key=$2
fi

while [[ -z "$key" ]]; do
  read -p "请输入cloudflare api key" key
done

echo -e "输入的key是：$key"

####开始创建docker
docker pull oznu/cloudflare-ddns

array=("main" "emby" "ssh")

# 使用for循环遍历数组
for item in "${array[@]}"; do
  echo $item
  name="cloudflare-ddns-$item"
  container=$(docker ps -q -f name=$name)
  if [ -z "$container" ]; then
    echo "容器不存在，正在创建容器 $name ..."
    docker run -d --name $name -d --net=host --restart="always" -e API_KEY=$key -e ZONE=$dns -e SUBDOMAIN=$item -e PROXIED=true -e RRTYPE=AAAA oznu/cloudflare-ddns
  else
    echo "$name 容器已存在 不用创建"
  fi
done
