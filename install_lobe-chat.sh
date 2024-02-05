#!/bin/bash
cd $(dirname $0)
#sudo tar -xzvf lobe-chat.tgz -C /opt
# 解压gz分卷
cd lobe-chat
sudo cat lobe-chat.tar.gz* | tar zx
sudo mv lobe-chat /opt
cp /opt/lobe-chat/lobe-chat.service /etc/systemd/system/
sudo systemctl enable lobe-chat.service
sudo systemctl start lobe-chat.service
