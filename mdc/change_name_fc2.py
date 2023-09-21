#!/usr/bin/python3

# 使用方法 :
# python3 change_name_fc2.py 需要更改的文件夹

# 修改文件文件夹下名 fc2ppv-7687686-1.mp4 为 fc2-7687686-cd1.mp4
# 修改文件文件夹下名 fc2ppv-7687686.mp4 为 fc2-7687686.mp4
# 修改文件文件夹下名 名字带有-U结尾 如：ABP-320-U.mp4 为 ABP-320.mp4
# 修改文件文件夹下名 名字带有-HD结尾 如：H0930-ki230902-HD.mp4 为 H0930-ki230902.mp4
# 修改文件文件夹下名 名字带有-SD结尾 如：H0930-ki230905-SD.mp4 为 H0930-ki230905.mp4
# 修改文件文件夹下名 名字带有-fhd结尾 如：H4610-ori1833-FHD.mp4 为 H4610-ori1833.mp4
# 修改文件文件夹下名 名字带有-uc结尾 如：H4610-ori1833-UC.mp4 为 H4610-ori1833.mp4
# 修改文件文件夹下名
# 修改文件文件夹下名
import re
import os
import sys

# 需要排除的文件夹
exclude = ["JAV_failed", 'JAV_output', '无码破解']
video_exclude = ['mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv']
replace_endswith = {
    # 'fc2ppv':"fc2", # 需要正则匹配这里不添加
    # '-u': '',
    # '-hd': '',
    # '-sd': '',
    # '-fhd': '',
    # '-uc': '',
    # '-uc-c': '-c',
}


class changefc2:

    # 找到所有文件
    def get_files_in_folder(self, folder_path):
        files = []
        for fpathe, dirs, fs in os.walk(folder_path):
            dirs[:] = [d for d in dirs if d not in exclude]
            # dirs[:] = [(d for d in dirs if d not in exclude) and (fs.endswith(end) for end in video_exclude)]
            for f in fs:
                for end in video_exclude:
                    if f.endswith(end):
                        files.append(os.path.join(fpathe, f))
        return files

    def __init__(self, folder_path="./"):
        print("开始扫描这个文件夹：", folder_path)
        files = self.get_files_in_folder(folder_path)
        for file in files:
            # 分里文件夹和文件
            file_path, file_name_all = os.path.split(file)
            file_name = os.path.splitext(file_name_all)[0]
            file_name_extension = os.path.splitext(file_name_all)[1]
            file_name = file_name.lower()
            isChange = False
            if re.search(r'fc2ppv-(\d)+', file_name, re.IGNORECASE):
                file_name = file_name.replace("fc2ppv", "fc2")
                num_re = re.search(r'-\d+-\d', file_name)
                if num_re:
                    num = num_re.group()[-1]
                    file_name = file_name[0:-1] + "cd" + num
                isChange = True
            else:
                for key in replace_endswith.keys():
                    if file_name.endswith(key):
                        file_name = file_name.replace(key, replace_endswith.get(key))
                        isChange = True
                        break
            if not isChange:
                continue
            file_name_all = file_name.upper() + file_name_extension
            print("修改文件{}为{}".format(file, os.path.join(file_path, file_name_all)))
            os.rename(file, os.path.join(file_path, file_name_all))


if __name__ == '__main__':
    changefc2(sys.argv[1] or None)
    # changefc2(os.path.join(os.path.abspath(''), "../test"))
