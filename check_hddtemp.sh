#!/bin/bash

hdds=(/dev/sdb /dev/sdc)

function check() {
  # 检测硬盘温度
  echo "$1"
  temp=$(hddtemp $1)
  echo
  echo "$temp"
  # 货物温度值
  temp=${temp:31:2}
  echo "$temp"
  ## 值是否大于50度
  if [ $temp -gt 50 ]; then
    echo "$1 当前硬盘温度是 $temp 大于设置的温度50 现在执行关机."
    #    shutdown -h now
    #    poweroff

  else
    echo "$1 当前硬盘温度是 $temp"
  fi

}

# 遍历数组中的元素和下标
for i in "${!hdds[@]}"; do
  # 在此处执行操作，使用 $i 和 ${array[$i]} 处理每个元素和下标
  check ${hdds[$i]}
done
