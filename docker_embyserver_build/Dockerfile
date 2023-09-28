FROM emby/embyserver:latest
#将宿主机的文件复制到镜像目录
COPY emby/*.dll /system
COPY plugins/*.dll /system/plugins
COPY embyWebAddExternalUrl /system/dashboard-ui/embyWebAddExternalUrl
COPY index.html /system/dashboard-ui/index.html
