#!/bin/sh
# 这个文件是复制到embyserver 的docker容器中运行的文件 在容器中执行添加web外部播放内容
wget https://github.com/bpking1/embyExternalUrl/archive/refs/tags/v0.0.6.zip
unzip v0.0.6.zip
cp -r embyExternalUrl-0.0.6/embyWebAddExternalUrl/ /system/dashboard-ui/
sed -i '88i\    <script src="embyWebAddExternalUrl/embyLaunchPotplayer.js"></script>' /system/dashboard-ui/index.html
rm v0.0.6.zip
rm -rf embyExternalUrl-0.0.6
rm emby_docker_install_webExPlayer.sh