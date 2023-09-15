#!/bin/bash

# 检测硬盘温度
temp=$(hddtemp /dev/sdc)

# 货物温度值
temp=${temp:29:2}
echo "$temp"
## 值是否大于50度
#if [ $temp -gt 50 ]; then
#  echo "当前硬盘温度是 $temp 大于设置的温度50 现在执行关机."
#  #    shutdown -h now
#  poweroff
#
#else
#  echo "当前硬盘温度是 $temp"
#fi
