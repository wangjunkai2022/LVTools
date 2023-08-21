#!/bin/bash
# 添加ipv6 定时刷新到 nginx的ipv6*.html 中
function echo_green() {
  echo -e "\033[32m$1\033[0m"
}
echo_green "是否执行定时检测ipv6地址到主页中?(y/n)"
read answer
if [ "$answer" == "y" ]; then
  cd $(dirname $0)
  sudo mv ./ipv6_check.sh /bin/ipv6_check.sh
  sudo chmod 777 /bin/ipv6_check.sh
  sudo crontab -l >conf && echo "*/1 * * * * ipv6_check.sh" >>conf && sudo crontab conf && sudo rm -f conf
fi
