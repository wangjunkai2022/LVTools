#!/bin/bash

#需要扫描的地址
path=/data/videos/media/alist/PikPak3/sehuatang/亚洲无码原创
filepath=$(
  cd "$(dirname "$0")"
  pwd
)

find $path -name "*社*區*最*新*情*報*" -print0 | xargs -0 rm -rf ##可以删除带空格
find $path -name "*x*u*u*c*o*m*" -print0 | xargs -0 rm -rf ##可以删除带空格
find $path -name "*新*片*首*發*每*天*更*新*同*步*日*韓*" -print0 | xargs -0 rm -rf ##可以删除带空格
find $path -name "*有*趣*的*臺*灣*妹*妹*直*播*" -print0 | xargs -0 rm -rf ##可以删除带空格
find $path -name "*妹*妹*在*精*彩*表*演*" -print0 | xargs -0 rm -rf ##可以删除带空格
find $path -name "*有*趣*的*小*视*频*" -print0 | xargs -0 rm -rf ##可以删除带空格
find $path -name "*新*片*首*发*" -print0 | xargs -0 rm -rf ##可以删除带空格
find $path -name "*社*区*最*新*情*报*" -print0 | xargs -0 rm -rf ##可以删除带空格
find $path -name "*有*趣*的*台*湾*妹*妹*直*播*" -print0 | xargs -0 rm -rf ##可以删除带空格

python3 $filepath/change_name_fc2.py "$path"

#docker pull ghcr.io/vergilgao/mdc:latest
docker pull xiaokai2022/mdc
#mkdir test
#dd if=/dev/zero of="./test/MIFD-046.mp4" bs=250MB count=1
#docker run --rm --name mdc_test -it -v ${PWD}/test:/data -v ${PWD}/config:/config -e UID=$(stat -c %u test) -e GID=$(stat -c %g test) ghcr.io/vergilgao/mdc:latest
#github AVDC
rm -rf ~/mdc_config
mkdir -p -m 777 ~/mdc_config
cp $(dirname $0)/mdc.ini ~/mdc_config/

docker run --rm --name mdc_test -e UID=0 -e GID=0 -it -v $path:/videos -v ~/mdc_config:/config xiaokai2022/mdc
#docker run --rm --name mdc_test1 -it -v $path:/videos -v ~/mdc_config:/config -e UID=0 -e GID=0 xiaokai2022/mdc
