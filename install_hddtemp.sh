#!/bin/bash

function echo_green() {
  echo -e "\033[32m$1\033[0m"
}
echo_green "是否执行安装自动检测硬盘温度 如果超过预设值则关机 y/r/n"
read answer
if [ "$answer" == "y" ]; then
  cd $(dirname $0)
  if [ $EUID -eq 0 ]; then
    echo "当前用户是root用户"
    cp ./check_hddtemp.sh /bin/check_hddtemp.sh
    chmod 777 /bin/check_hddtemp.sh
    crontab -l >conf && echo "*/5 * * * * check_hddtemp.sh" >>conf && crontab conf && rm -f conf
  else
    echo "当前用户不是root用户"
    sudo cp ./check_hddtemp.sh /bin/check_hddtemp.sh
    sudo chmod 777 /bin/check_hddtemp.sh
    sudo crontab -l >conf && echo "*/5 * * * * check_hddtemp.sh" >>conf && sudo crontab conf && sudo rm -f conf
  fi
  echo "ok已经添加定时执行 自动检测硬盘温度 如果超过预设值则关机"
elif [ "$answer" == "r" ]; then
  cd $(dirname $0)
  if [ $EUID -eq 0 ]; then
    echo "当前用户是root用户"
    cp ./check_hddtemp.sh /bin/check_hddtemp.sh
    chmod 777 /bin/check_hddtemp.sh
  else
    echo "当前用户不是root用户"
    sudo cp ./check_hddtemp.sh /bin/check_hddtemp.sh
    sudo chmod 777 /bin/check_hddtemp.sh
  fi
  echo "ok已经覆盖了 /bin/check_hddtemp.sh 文件"
fi
