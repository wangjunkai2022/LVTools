#!/bin/bash

#需要扫描的地址
path=/data/videos/media/alist/PikPak/无码
filepath=$(
  cd "$(dirname "$0")"
  pwd
)
python3 $filepath/change_name_fc2.py "$path"

#find $path -name "社 區 最 新 情 報*" -print0 | xargs -0 rm -rf ##可以删除带空格
##find $path -name "x u u 6 2 . c o m*" | xargs rm -rf
#find $path -name "x u u 6 2 . c o m*" -print0 | xargs -0 rm -rf ##可以删除带空格
#
##docker pull ghcr.io/vergilgao/mdc:latest
#docker pull xiaokai2022/mdc
##mkdir test
##dd if=/dev/zero of="./test/MIFD-046.mp4" bs=250MB count=1
##docker run --rm --name mdc_test -it -v ${PWD}/test:/data -v ${PWD}/config:/config -e UID=$(stat -c %u test) -e GID=$(stat -c %g test) ghcr.io/vergilgao/mdc:latest
##github AVDC
#rm -rf ~/mdc_config
#mkdir -p -m 777 ~/mdc_config
#cp $(dirname $0)/mdc.ini ~/mdc_config/
#
##docker run --rm --name mdc_test -it -v $path:/videos -v ~/mdc_config:/config ghcr.io/vergilgao/mdc:latest
#docker run --rm --name mdc_test -it -v $path:/videos -v ~/mdc_config:/config -e UID=0 -e GID=0 xiaokai2022/mdc
