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
import shutil
import sys

# 需要排除的文件夹
import time

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


# 找到所视频文件
def _get_files_in_folder(folder_path):
    files = []
    for fpathe, dirs, fs in os.walk(folder_path):
        dirs[:] = [d for d in dirs if d not in exclude]
        # dirs[:] = [(d for d in dirs if d not in exclude) and (fs.endswith(end) for end in video_exclude)]
        for f in fs:
            for end in video_exclude:
                if f.endswith(end):
                    files.append(os.path.join(fpathe, f))
    return files


# 返回文件名和后缀
def _GetFileNameAll(file):
    file_path, file_name_all = os.path.split(file)
    file_name = os.path.splitext(file_name_all)[0]
    file_name_extension = os.path.splitext(file_name_all)[1]
    return file_name, file_name_extension, file_path


class changefc2:

    def __init__(self, folder_path="./"):
        print("开始扫描这个文件夹：", folder_path)
        files = _get_files_in_folder(folder_path)
        # files = ["/data/videos/media/alist/SukebeiEnyo合集一/SukebeiEnyo合集一/Fc2 PPV 2634136/Fc2 PPV 2634136 1.mp4", ]
        for file in files:
            # 分里文件夹和文件
            file_name, file_name_extension, file_path = _GetFileNameAll(file)
            file_name = file_name.lower()
            isChange = False
            if re.search(r'fc2ppv-(\d)+', file_name, re.IGNORECASE) \
                    or re.search(r"Fc2 PPV (\d)+", file_name, re.IGNORECASE) \
                    or re.search(r"Fc2 PPV  (\d)+", file_name,
                                 re.IGNORECASE):
                file_name = file_name.replace("fc2ppv", "fc2")
                file_name = file_name.replace("fc2 ppv ", "fc2-")
                file_name = file_name.replace("fc2 ppv  ", "fc2-")
                num_re = re.search(r'-\d+-\d', file_name) or re.search(r'-\d+ \d', file_name)
                if num_re:
                    num = num_re.group()[-1]
                    file_name = file_name[0:-2] + "-cd" + num
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
            __file_name_all_path = os.path.join(file_path, file_name_all)
            try:
                # while not os.path.exists(__file_name_all_path):
                #     print("修改文件{}为{}".format(file, __file_name_all_path))
                #     os.rename(file, __file_name_all_path)
                #     time.sleep(1)
                print("修改文件\n{}\n为\n{}\n".format(file, __file_name_all_path))
            except OSError as e:
                print("移动失败:{}".format(e))


# 替换ABCD-GHI到CD1-9
class ChangeABC2CD:
    __number_list = {
        "A": "CD1",
        "B": "CD2",
        "C": "CD3",
        "D": "CD4",
        "E": "CD5",
        "F": "CD6",
        "G": "CD7",
        "H": "CD8",
        "I": "CD9",
    }

    def __init__(self, folder_path="./"):
        print("开始扫描这个文件夹：", folder_path)
        __files = _get_files_in_folder(folder_path)
        __sames = {}
        for file in __files:
            file_name, file_name_extension, file_path = _GetFileNameAll(file)
            file_name2lower = file_name.lower()
            name = file_name2lower[0:-1]
            name_k = file_name2lower[-1]
            if re.search(r"\d", name_k):
                pass
            else:
                if name in __sames:
                    __sames[name].append(file)
                else:
                    __sames[name] = [
                        file
                    ]
        for name, items in __sames.items():
            if len(items) > 0:
                for file in items:
                    file_name, file_name_extension, file_path = _GetFileNameAll(file)
                    number = file_name[-1]
                    file_name = file_name[0:-1]
                    # print(number)
                    # print(file_path)
                    # print(file_name)
                    # print(file)
                    try:
                        file_name = file_name + "-" + self.__number_list[number] + file_name_extension
                    except KeyError as e:
                        print("获取key失败 当前文件:{}".format(file))
                        continue
                    # print(file_name)
                    # file_path = os.path.join(file_path, "../", file_name)
                    file_path = os.path.join(file_path, file_name)
                    # print(file_path)
                    try:
                        while not os.path.exists(file_path):
                            print("开始移动文件:\n{}\n{}".format(file, file_path))
                            # shutil.move(file, file_path)
                            os.rename(file, file_path)
                            time.sleep(1)
                    except OSError as e:
                        print("移动失败:{}".format(e))
        # print(__sames)


class CD2CD:
    def __init__(self, path, path2):
        videos = _get_files_in_folder(path)
        for file in videos:
            file_name, file_name_extension, file_path = _GetFileNameAll(file)
            if re.search("-cd(\d)+", file_name, re.IGNORECASE):
                new_path = os.path.join(file_path, path2, file_name + file_name_extension)
                try:
                    while not os.path.exists(new_path):
                        print("开始移动文件:\n{}\n{}".format(file, new_path))
                        shutil.move(file, new_path)
                        # os.rename(file, new_path)
                        time.sleep(1)
                except OSError as e:
                    print("移动失败:{}".format(e))


if __name__ == '__main__':
    changefc2(sys.argv[1] or None)
    # ChangeABC2CD(sys.argv[1] or None)
    # CD2CD(sys.argv[1] or None, "../")
    # changefc2()
