#!/usr/bin/python3

# 修改文件文件夹下名 fc2ppv-7687686-1.mp4 为 fc2-7687686-cd1.mp4
# 修改文件文件夹下名 fc2ppv-7687686.mp4 为 fc2-7687686.mp4
import re
import os
import sys

# 需要排除的文件夹
exclude = ["JAV_failed", 'JAV_output']


class changefc2:

    # 找到所有文件
    def get_files_in_folder(self, folder_path):
        files = []
        for fpathe, dirs, fs in os.walk(folder_path):
            dirs[:] = [d for d in dirs if d not in exclude]
            for f in fs:
                files.append(os.path.join(fpathe, f))
        return files

    def __init__(self, folder_path="./"):
        print("开始扫描这个文件夹：", folder_path)
        files = self.get_files_in_folder(folder_path)
        print(files)
        return
        for file in files:
            # 分里文件夹和文件
            file_path, file_name = os.path.split(file)
            lower_check = file_name.lower()
            # fc2
            fc2cd = re.search(r'fc2ppv-(\d)+', lower_check, re.IGNORECASE)
            if fc2cd:
                lower_check = lower_check.replace("fc2ppv", "fc2")
                num_re = re.search(r'-\d\.', lower_check)
                if num_re:
                    num = num_re.group()
                    lower_check = re.sub(r'-\d\.', "-cd" + num[1:len(num) - 1] + ".", lower_check)
                print("修改文件{}为{}".format(file, os.path.join(file_path, lower_check)))
                os.rename(file, os.path.join(file_path, lower_check))

            # 名字带有-U结尾 如：ABP-320-U.mp4
            _u = re.search(r'-u.', lower_check, re.IGNORECASE)
            if _u:
                lower_check = lower_check.replace("-u.", ".")
                print("修改文件{}为{}".format(file, os.path.join(file_path, lower_check)))
                os.rename(file, os.path.join(file_path, lower_check))
            # 名字带有-HD结尾 如：H0930-ki230902-HD.mp4
            _hd = re.search(r'-hd.', lower_check, re.IGNORECASE)
            if _hd:
                lower_check = lower_check.replace("-hd.", ".")
                print("修改文件{}为{}".format(file, os.path.join(file_path, lower_check)))
                os.rename(file, os.path.join(file_path, lower_check))

            # 名字带有-SD结尾 如：H0930-ki230905-SD.mp4
            _sd = re.search(r'-sd.', lower_check, re.IGNORECASE)
            if _sd:
                lower_check = lower_check.replace("-sd.", ".")
                print("修改文件{}为{}".format(file, os.path.join(file_path, lower_check)))
                os.rename(file, os.path.join(file_path, lower_check))

            # 名字带有-fhd结尾 如：H4610-ori1833-FHD.mp4
            _fhd = re.search(r'-fhd.', lower_check, re.IGNORECASE)
            if _fhd:
                lower_check = lower_check.replace("-fhd.", ".")
                print("修改文件{}为{}".format(file, os.path.join(file_path, lower_check)))
                os.rename(file, os.path.join(file_path, lower_check))


if __name__ == '__main__':
    changefc2(sys.argv[1])
