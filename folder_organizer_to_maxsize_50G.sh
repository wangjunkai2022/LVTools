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

  #  shopt -s globstar

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
      echo "创建文件夹:${new_folder}"
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
      echo "替换文件：$file 为:$newfile"
      mv "$file" "$newfile"
    done

}

remove_MacOs_File() {
  path=$1
  if [ ! -d "$path" ]; then
    echo "$path 路径不存在"
    exit 1
  fi
  find "$path" -depth -name ".*" -type f |
    while IFS= read -r file; do
      echo "删除文件$file"
      rm "$file"
    done

  find "$path" -depth -name "*DS_Store*" -type f |
    while IFS= read -r file; do
      echo "删除文件$file"
      rm "$file"
    done

  find "$path" -depth -name "*(*).*" -type f |
    while IFS= read -r file; do
      echo "删除文件$file"
      rm "$file"
    done

  find "$path" -depth -name "*(*)" -type d |
    while IFS= read -r dir; do
      echo "删除文件$dir"
      rm -rf "$dir"
    done
}

folder_remove_child1leave() {
  path=$1
  temp_path="${path}_temp"
  mkdir -p $temp_path
  if [ ! -d "$path" ]; then
    echo "$path 路径不存在"
    exit 1
  fi
  for dir in "$path"/*/; do
    echo "$dir"
    mv "$dir"* "$temp_path"
  done
  #  rm -rf $path
  #  mv $temp_path $path

  #  #    find "$path" -maxdepth 2 -type d | while read -r dir; do # 这个会显示原文件夹
  #  # 查找2级子目录
  #  find "$path" -maxdepth 1 -type d | while read -r dir; do
  #    if [ "$dir" == "$path" ]; then
  #      echo
  #    else
  #      echo "开始移动文件$dir 到 $path"
  #      #    mv "$dir" "$path"
  #      echo "$dir" "$path"
  #    fi
  #    #    find "$dir" -mindepth 1 -type d -exec mv -t "$path" {} +
  #    #    find "$dir" -mindepth 1 -type d -exec -empty -delete
  #    #        echo "$dir"
  #    #    echo "开始移动文件$dir 到 $path"
  #    #    #    mv "$dir" "$path"
  #    #    echo "$dir" "$path"
  #  done
  #  find "$path" -mindepth 1 -type d -empty -delete

  #  subdirs=$(find "$path" -maxdepth 1 -type d)
  #  for subdir in $subdirs; do
  #    find "$subdir" -type f -exec mv {} "$path" \;
  #  done
}

function move_failed_to_folder() {
  path=$1
  temp_path="${path}_temp"
  mkdir -p $temp_path
  if [ ! -d "$path" ]; then
    echo "$path 路径不存在"
    exit 1
  fi

  find "$path" ! \( -name "*u*u*r*" -o -name ".*" -o -name "*DS_Store*" \) -type f |
    while IFS= read -r file; do
      new_file=${file/$path/$temp_path}
      new_dir=$(dirname "$new_file")
      mkdir -p "$new_dir"
      echo "移动文件$file 到 $new_dir 下"
      mv "$file" "$new_dir"
    done
}

find_Have_rename() {
  path=$1
  if [ ! -d "$path" ]; then
    echo "$path 路径不存在"
    exit 1
  fi
  rep='_Have'
  find "$path" -depth -name "*-Have*" -type f |
    while IFS= read -r file; do
      newfile=$(dirname "$file")/$(basename "$file" | sed "s/\-Have/$rep/")
      echo "替换文件夹：$file 为:$newfile"
      mv "$file" "$newfile"
    done
}

_find_mp4_videos() {
  dir_name=$1
  nfo_fname=$2
  if [ ! -d "$dir_name" ]; then
    echo "$dir_name 路径不存在"
    exit 1
  fi
  find "$dir_name" -name "*.mp4" |
    while IFS= read -r video_file; do
      video_file_name=$(basename "$video_file")
      video_ext=".${video_file##*.}"
      video_fname=$(basename $video_file $video_ext) # 剃出后缀的视频名字
      #          echo "$video_ext"
      if [[ $video_fname =~ $nfo_fname ]]; then
        echo
        #            echo "包含"
        #            echo "nfo:$nfo_file_name video:$video_file_name"
      else
        echo "不包含"
        echo "nfo:$nfo_file_name video:$video_file_name"
        new_file_video_name="${dir_name}/${nfo_fname}${video_ext}"
        count=${video_fname: -1:1}

        if grep '^[[:digit:]]*$' <<<"$count"; then
          echo "获取到最后一个是数字:$count "
        else
          echo '最后一个值不是数字'
          count=0
        fi

        while [ -f "$new_file_video_name" ]; do
          new_file_video_name="${dir_name}/${nfo_fname}_Have${count}${video_ext}"
          count=$((count + 1))
        done
        echo "文件替换:$video_file 为:$new_file_video_name count:$count"
        #            echo "$count"
      fi
    done
}

find_all_video_rename_2_nfo() {
  path=$1
  if [ ! -d "$path" ]; then
    echo "$path 路径不存在"
    exit 1
  fi
  find "$path" -name "*.nfo" -type f |
    while IFS= read -r nfo_file; do
      dir_name=$(dirname "$nfo_file")
      nfo_file_name=$(basename "$nfo_file")
      nfo_ext=".${nfo_file##*.}"
      nfo_fname=$(basename $nfo_file $nfo_ext) # 剃出后缀的nfo名字
      #      echo "$dir_name"
      _find_mp4_videos $dir_name $nfo_fname
    done
}

path=$1
# 路径中删除最后的/
if echo "$path" | grep -q -E '\/$'; then
  path=${path:0:$((${#path} - 1))}
fi

#remove_MacOs_File $path
#remove_all_space2_ $path
#folder_remove_child1leave $path
folder_organizer_max50G $path
#echo "$path"
#move_failed_to_folder $path
#find_Have_rename $path
#find_all_video_rename_2_nfo $path
# echo "All files have been moved to new folders."
