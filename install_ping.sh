#!/bin/sh
# 安装定时ping路由 需要先去设置路由ip的地址
sudo mv ./auto_ping.sh /bin/yy_auto_ping.sh
sudo chmod 777 /bin/yy_auto_ping.sh
sudo crontab -l >conf && echo "*/1 * * * * yy_auto_ping.sh" >>conf && sudo crontab conf && sudo rm -f conf
sudo rm -rf ./install_ping.sh
