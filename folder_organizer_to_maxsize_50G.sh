#!/bin/bash

folder_organizer_max50G() {
  source_folder=$1
  if [ ! -d "$source_folder" ]; then
    echo "$source_folder 路径不存在"
    exit 1
  fi
  max_size=$((50 * 1024 * 1024))

  current_size=$max_size
  folder_counter=1

  shopt -s globstar

  # 获取源文件夹下的所有文件和文件夹
  processed_folders=0
  count=$(ls -l $source_folder | grep "^d" | wc -l)
  echo "子文件个数为：$count"

  # 移动文件到新文件夹
  for file in "$source_folder"/*/; do
    file_size=$(du -s "${file}" | awk '{print $1}')
    current_size=$(($current_size + $file_size))

    if [ $current_size -gt $max_size ]; then
      # 如果新文件夹大小超过了最大限制，创建新的文件夹
      new_folder="${source_folder%/}/max_folder_50G_${folder_counter}"
      mkdir -p "${new_folder}"
      echo "模拟创建${new_folder}"
      current_size=$file_size
      folder_counter=$((folder_counter + 1))
    fi

    mv "${file}" "${new_folder}/"
    echo "移动 ${file} 到 ${new_folder} 当前新文件夹大小${current_size}"
    echo "文件名:$file :文件大小：$file_size"
    # 更新进度信息
    processed_folders=$((processed_folders + 1))
    remaining_folders=$((count - processed_folders))
    echo "移动文件: $file (剩余文件夹数: $remaining_folders)"
    echo
    echo
  done
}

# 删除所有的文件夹的空格
remove_all_space2_() {
  path=$1
  if [ ! -d "$path" ]; then
    echo "$path 路径不存在"
    exit 1
  fi
  rep='-'
  find "$path" -depth -name "* *" -type d |
    while IFS= read -r dir; do
      newdir=$(dirname "$dir")/$(basename "$dir" | tr ' ' "$rep")
      echo "替换文件夹：$dir 为:$newdir"
      mv "$dir" "$newdir"
    done
  find "$path" -depth -name "* *" -type f |
    while IFS= read -r file; do
      newfile=$(dirname "$file")/$(basename "$file" | tr ' ' "$rep")
      echo "替换文件夹：$file 为:$newfile"
      mv "$file" "$newfile"
    done

}

path=$1
# 路径中删除最后的/
if echo "$path" | grep -q -E '\/$'; then
  path=${path:0:$((${#path} - 1))}
fi

folder_remove_child1leave() {
  path=$1
  if [ ! -d "$path" ]; then
    echo "$path 路径不存在"
    exit 1
  fi

  #    find "$path" -maxdepth 2 -type d | while read -r dir; do # 这个会显示原文件夹
  # 查找2级子目录
  find "$path" -mindepth 2 -type d | while read -r dir; do
    #    find "$dir" -mindepth 1 -type d -exec mv -t "$path" {} +
    #    find "$dir" -mindepth 1 -type d -exec -empty -delete
    #        echo "$dir"
    echo "开始移动文件$dir 到 $path"
    mv "$dir" "$path"
  done
  find "$path" -mindepth 1 -type d -empty -delete
}
remove_all_space2_ $path
folder_remove_child1leave $path
# echo "$files"

# echo "All files have been moved to new folders."
