#!/bin/bash

chown -R ${PUID}:${PGID} /opt/alist/

umask ${UMASK}


if [ "$1" = "version" ]; then
    ./alist version
else
    exec su-exec ${PUID}:${PGID} ./alist server --no-prefix
    # 检查是否为第一次启动，通过查看一个特定文件是否存在
    if [ ! -f /opt/alist/.initialized ]; then
        # 检查 ALIST_PASSWORD 环境变量是否存在
        if [ -n "${ALIST_PASSWORD}" ]; then
            echo "第一次运行 这里等待60秒会重新设置一下密码为:${ALIST_PASSWORD}"
            sleep 60
            ./alist admin set "${ALIST_PASSWORD}"  # 设置密码
        else
            echo "不设置默认密码"
        fi
        touch /opt/alist/.initialized  # 创建标记文件，表示已初始化
    fi
fi
