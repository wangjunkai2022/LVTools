#!/bin/bash

source_folder=$1
max_size=$((50*1024*1024))

current_size=$max_size
folder_counter=1

shopt -s globstar

# 获取源文件夹下的所有文件和文件夹
processed_folders=0
count=$(ls -l $source_folder | grep "^d" | wc -l)
echo "子文件个数为：$count"

# 移动文件到新文件夹
for file in "$source_folder"*/ ; do
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
# echo "$files"

# echo "All files have been moved to new folders."
