#!/bin/bash
# 查找文件夹下相同的文件

# 指定要查找重复文件的目录
directory="."

# 使用find命令查找目录下的所有文件，并计算其md5sum值
find "$directory" -type f -exec md5sum {} + | sort >filelist.txt

# 使用awk命令找出重复的文件，并将其路径保存到文件中
awk '{print $1}' filelist.txt | uniq -d >duplicates.txt

# 使用while循环逐行读取重复文件的路径，并删除之
while read -r line; do
  grep $line filelist.txt | awk '{print $2}' | xargs echo ## 这里不删除 只是打印出来就好了
  #  grep $line filelist.txt | awk '{print $2}' | xargs rm -rf ## 删除
done <duplicates.txt

# 删除临时文件
rm filelist.txt
rm duplicates.txt
