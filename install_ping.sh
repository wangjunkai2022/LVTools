#!/bin/bash
# 安装定时ping路由 需要先去设置路由ip的地址

function echo_green() {
  echo -e "\033[32m$1\033[0m"
}
echo_green "是否执行ping不通自动关机的脚本添加到系统定时执行?(y/n)"
read answer
if [ "$answer" == "y" ]; then
  cd $(dirname $0)
  echo_green "请输入需要ping的ip地址 一般填写路由器的ip即可"
  read input_ip

  sed "s/0.0.0.0/$input_ip/g" -i ./auto_ping.sh

  if [ $EUID -eq 0 ]; then
    echo "当前用户是root用户"
    cp ./auto_ping.sh /bin/yy_auto_ping.sh
    chmod 777 /bin/yy_auto_ping.sh
    crontab -l >conf && echo "*/1 * * * * yy_auto_ping.sh" >>conf && crontab conf && rm -f conf
  else
    echo "当前用户不是root用户"
    sudo cp ./auto_ping.sh /bin/yy_auto_ping.sh
    sudo chmod 777 /bin/yy_auto_ping.sh
    sudo crontab -l >conf && echo "*/1 * * * * yy_auto_ping.sh" >>conf && sudo crontab conf && sudo rm -f conf
  fi

#  sudo rm -rf ./install_ping.sh
fi
