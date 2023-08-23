#nginx官方包
FROM nginx:1.24.0-alpine
#各模块版本变量参数
ARG NGINX_VERSION=1.24.0
ARG NGX_WEBDAV_VERSION=3.0.0
#将宿主机的文件复制到镜像目录
COPY ./dav-${NGX_WEBDAV_VERSION}.tar.gz /tmp
#换国内清华源,阿里源很慢
RUN cat /etc/apk/repositories | sed -e "s/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/" | tee /etc/apk/repositories
#编译环境
RUN apk add --no-cache --virtual .build-deps gcc libc-dev make openssl-dev pcre2-dev zlib-dev linux-headers libxslt-dev gd-dev geoip-dev perl-dev libedit-dev mercurial bash alpine-sdk findutils && \
    mkdir -p /usr/src && cd /usr/src && \
    curl -L "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -o nginx.tar.gz && \
    tar zxvf /tmp/dav-${NGX_WEBDAV_VERSION}.tar.gz && mv nginx-dav-ext-module-${NGX_WEBDAV_VERSION} ngx_dav && \
    tar -zxC /usr/src -f nginx.tar.gz && \
    cd /usr/src/nginx-$NGINX_VERSION && \
    CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
    CONFARGS=${CONFARGS/-Os -fomit-frame-pointer -g/-Os} && \
    echo $CONFARGS && \
    ./configure --with-compat $CONFARGS --with-http_dav_module --add-module=../ngx_dav/ && \
    make && make install && \
    apk del .build-deps && \
    rm -rf /tmp/* && rm -rf /var/cache/apk/* && rm -rf /usr/src/