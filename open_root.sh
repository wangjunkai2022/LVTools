#!/bin/bash

# 设置 root 用户密码
sudo passwd root

# 启用 root 用户帐户
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd.service
