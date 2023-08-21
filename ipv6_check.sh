#!/bin/bash
cd $(dirname $0)
# 获取ipv6
ip=$(ip -6 addr show | grep -oP '([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|')
#echo $ip
change='--ipv6--'
sed "s/$change/$ip/g" ipv6_hyperlink.html > /data/videos/tools/nginx/www/html/ipv6_hyperlink.html