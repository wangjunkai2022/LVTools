#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
source /etc/profile
hdds=(/dev/sdb /dev/sdc)

function check() {
  # 检测硬盘温度
  temp=$(hddtemp $1)
  # 匹配温度值
  temp_regex='[+-]?[0-9]+([.][0-9]+)?°?[CF]'
  temp=$(echo "$temp" | grep -oE "$temp_regex")

  # 温度值
  temp=${temp:0:2}
  ## 值是否大于50度
  if [ $temp -gt 50 ]; then
    echo $(date "+%Y%m%d %H:%M:%S") "$1 当前硬盘温度是 $temp 大于设置的温度50 现在执行关机."
    #    shutdown -h now
    poweroff

  else
    echo $(date "+%Y%m%d %H:%M:%S") "$1 当前硬盘温度是 $temp"
  fi

}

# 遍历数组中的元素和下标
for i in "${!hdds[@]}"; do
  # 在此处执行操作，使用 $i 和 ${array[$i]} 处理每个元素和下标
  check ${hdds[$i]}
done
