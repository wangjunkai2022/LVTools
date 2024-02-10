#!/bin/bash
# 整理文件为50G大小的新文件

# 获取传入的文件夹路径
folder_path=$1

# 检查路径是否存在
if [ ! -d "$folder_path" ]; then
  echo "文件夹路径不存在"
  exit 1
fi

# 创建目标文件夹
mkdir -p "${folder_path}_organized"

# 获取子文件夹列表
subfolders=$(find "$folder_path" -mindepth 1 -type d)

# 初始化计数器和目标文件夹大小
count=0
folder_size=0

# 遍历子文件夹列表
for subfolder in $subfolders; do
  # 获取子文件夹大小（以字节为单位）
  size=$(du -sb "$subfolder" | awk '{print $1}')

  # 判断是否需要创建新的目标文件夹
  if [ $((folder_size + size)) -ge 50000000000 ]; then
    count=$((count + 1))
    mkdir -p "${folder_path}_organized/folder$count"
    folder_size=0
  fi

  # 获取子文件夹相对路径
  relative_path="${subfolder#$folder_path}"

  # 在目标文件夹中创建对应的子文件夹
  mkdir -p "${folder_path}_organized/folder$count$relative_path"

  # 移动子文件夹中的文件到目标文件夹
  mv -n "$subfolder"/* "${folder_path}_organized/folder$count$relative_path"

  # 累加目标文件夹大小
  folder_size=$((folder_size + size))
done
