#!/bin/bash
# 安装 embyserver web 第三方应用打开
cd $(dirname $0)
docker cp emby_docker_install_webExPlayer.sh embyserver:/
docker exec embyserver sh emby_docker_install_webExPlayer.sh
docker restart embyserver