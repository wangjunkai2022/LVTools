#!/bin/bash
cd $(dirname $0)
curl -O -L https://github.com/wangjunkai2022/lobe-chat/releases/download/1.0/lobe-chat.tgz
sudo tar -xzvf lobe-chat.tgz -C /opt
# 解压gz分卷
#cd lobe-chat
#sudo cat lobe-chat.tar.gz* | tar zx
#sudo mv lobe-chat /opt
cp /opt/lobe-chat/lobe-chat.service /etc/systemd/system/
sudo systemctl enable lobe-chat.service
sudo systemctl start lobe-chat.service
