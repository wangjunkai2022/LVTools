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
video_exclude = ['mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv', 'ts']
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
                if f.lower().endswith(end):
                    files.append(os.path.join(fpathe, f))
    return files


# 返回文件名和后缀
def _GetFileNameAll(file):
    file_path, file_name_all = os.path.split(file)
    file_name = os.path.splitext(file_name_all)[0]
    file_name_extension = os.path.splitext(file_name_all)[1]
    return file_name, file_name_extension, file_path


class ChangeFc2ppvToFC2:

    def __init__(self, folder_path="./"):
        print("开始扫描这个文件夹：", folder_path)
        files = _get_files_in_folder(folder_path)
        # files = ["/videos/SukebeiEnyo合集一/Fc2 PPV 1535736- 1541275-1525602(Uncensored Leaked) 【無修正】由○可○ 流出 part 3/Fc2 PPV 1535736 (Uncensored Leaked)【初流出】星野 瞳【削除必須】某メーカーからの流出作品① (Hitomi Hoshino ).mp4", ]
        for file in files:
            # 分里文件夹和文件
            file_name, file_name_extension, file_path = _GetFileNameAll(file)
            file_name = file_name.lower()
            file_name = file_name.replace("  ", " ")
            isChange = False
            if re.search(r'fc2ppv-(\d)+', file_name, re.IGNORECASE) \
                    or re.search(r"Fc2 PPV (\d)+", file_name, re.IGNORECASE):
                file_name = file_name.replace("fc2ppv", "fc2")
                file_name = file_name.replace("fc2 ppv ", "fc2-")
                # file_name = file_name.replace("fc2 ppv  ", "fc2-")
                # num_re = re.search(r'- \d+-\d', file_name)
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
                while not os.path.exists(__file_name_all_path):
                    print("修改文件\n{}\n为\n{}".format(file, __file_name_all_path))
                    os.rename(file, __file_name_all_path)
                    time.sleep(1)
                # print("修改文件\n{}\n为\n{}\n".format(file, __file_name_all_path))
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


def __subRepl(s):
    s = re.sub("(\s|-|_)", "", s.group())
    number = int(f"0x{s}", 16) - 9
    return f"-CD{number}"


class ChangeRuleToNumber:
    # __G_TAKE_NUM_RULES = {
    #     "ABP": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("ABP\s+", "ABP-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "ABW": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("ABW\s+", "ABW-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "ADN": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                       str(re.sub("ADN\s+", "ADN-", x, re.IGNORECASE)))
    #                )
    #     ),
    #     "AVO": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("AVO(P)?\s+", "AVOP-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "BBI": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("BBI\s+", "BBI-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "BGN": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl, str(re.sub("BGN\s+", "BGN-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "BIJN": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("BIJN\s+", "BIJN-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "DASD": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("DASD\s+", "DASD-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "DV": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl, str(re.sub("DV\s+", "DV-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "EBOD": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("EBOD\s+", "EBOD-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "EYAN": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("EYAN\s+", "EYAN-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "FC2": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("FC2\s+(PPV)?\s+", "FC2-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "FCDSS": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("FCDSS\s+", "FCDSS-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "HBAD": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("HBAD\s+", "HBAD-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "HND": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("HND\s+", "HBAD-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "HUNTB": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("HUNTB\s+", "HUNTB-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "IPTD": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("IPTD\s+", "IPTD-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "IPX": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("IPX\s+", "IPX-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "IPZ": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("IPZ\s+", "IPZ-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "JUL": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("JUL\s+", "JUL-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "JUX": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("JUX\s+", "JUX-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "MDYD": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("MDYD\s+", "MDYD-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "MIAD": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("MIAD\s+", "MIAD-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "MIDD": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("MIDD\s+", "MIDD-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "MIDE": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("MIDE\s+", "MIDE-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "MIGD": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("MIGD\s+", "MIGD-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "MXGS": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("MXGS\s+", "MXGS-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "ONED": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("ONED\s+", "ONED-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "PGD": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("PGD\s+", "PGD-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "PPPD": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("PPPD\s+", "PPPD-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "PRED": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("PRED\s+", "PRED-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "RBD": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("RBD\s+", "RBD-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "RBK": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("RBK\s+", "RBK-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "SDNM": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("SDNM\s+", "SDNM-", x, re.IGNORECASE))
    #                )
    #     ),
    #     "SEND": lambda x: str(
    #         re.sub("(\s|-|_)[A-F](\s+|-|_)?", __subRepl,
    #                str(re.sub("SEND\s+", "SEND-", x, re.IGNORECASE))
    #                )
    #     ),
    # 
    # }

    def __init__(self, path):
        videos = _get_files_in_folder(path)
        for file in videos:
            file_name, file_name_extension, file_path = _GetFileNameAll(file)
            # for k, v in self.__G_TAKE_NUM_RULES.items():
            #     if re.search(k, file_name, re.I):
            #         filename = v(file_name)
            #         if filename != file_name:
            #             new_file_all_name = os.path.join(file_path, filename + file_name_extension)
            #             print(f"文件\n{file}\n替换为\n{new_file_all_name}")
            # re_name = re.search(r"[A-Z]+(\s|-|_)+\d\d\d(?!\d)", file_name)
            # if re_name:
            #     print(f"文件名是：\n{file_name}\n匹配的字段是：\n{re_name.group()}")
            #     continue

            # re_name = re.search("FC2(\s|-|_)*\d{7}", file_name.upper())
            # if re_name:
            #     print(f"FC2文件名是：\n{file_name}\n匹配的字段是：\n{re_name.group()}")
            #     continue

            re_name = re.search(r"FC2(?=(\s|-|_)PPV)", file_name.upper())
            if re_name:
                print(f"FC2文件名是222：\n{file_name}\n匹配的字段是：\n{re_name.group()}123123")
                continue


if __name__ == '__main__':
    # ChangeFc2ppvToFC2(sys.argv[1] or None)
    ChangeRuleToNumber(sys.argv[1] or None)
    # ChangeABC2CD(sys.argv[1] or None)
    # CD2CD(sys.argv[1] or None, "../")
    # changefc2()
    # substr = re.sub("(\s|-|_)[A-F](\s+|-|_)?", sub, "HUNTB 079 A")
    # print(substr)
    # file_name = "FC2 PPV 2539001 【100個限定2980→1480ptにOFF!】ほぼ処女？ガチ素人！人生2回目のセックス！処女喪失時にトラウマになり…、緊張感伝わるガチ映像です。※レビュー特典／高画質Ver.TS"
    # re_name = re.search("FC2(?=(\s|\w))*(\s|-|_)*\d{7}", file_name.upper())
    # print(re_name)
