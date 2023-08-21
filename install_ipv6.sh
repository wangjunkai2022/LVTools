#!/bin/bash
# 添加ipv6 定时刷新到 nginx的ipv6*.html 中
function echo_green() {
  echo -e "\033[32m$1\033[0m"
}
echo_green "是否执行定时检测ipv6地址到主页中?(y/n)"
read answer
if [ "$answer" == "y" ]; then

  if [ $EUID -eq 0 ]; then
    echo "当前用户是root用户"
    cd $(dirname $0)
    cp ./ipv6_check.sh /bin/ipv6_check.sh
    cp ./ipv6_hyperlink.html /bin/ipv6_hyperlink.html
    chmod 777 /bin/ipv6_check.sh
    crontab -l >conf && echo "*/1 * * * * ipv6_check.sh" >>conf && crontab conf && rm -f conf
  else
    echo "当前用户不是root用户"
    sudo cp ./ipv6_check.sh /bin/ipv6_check.sh
    sudo cp ./ipv6_hyperlink.html /bin/ipv6_hyperlink.html
    sudo chmod 777 /bin/ipv6_check.sh
    sudo crontab -l >conf && echo "*/1 * * * * ipv6_check.sh" >>conf && sudo crontab conf && sudo rm -f conf
  fi

  echo "ok已经添加定时执行检测ipv6"
fi
