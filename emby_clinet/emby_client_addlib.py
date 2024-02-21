# -*- coding: utf-8 -*-
import os
import sys

import requests
import time
import json

import urllib

# emby服务器的URL和API密钥
server_url = ''
api_key = ''


def 读取新建媒体Json(文件名字: str):
    if not 文件名字.endswith("json"):
        文件名字 = f"{文件名字}.json"

    path = os.path.abspath(os.path.dirname(__file__))
    with open(f"{os.path.join(path, 文件名字)}", 'r') as f:
        jsonData = json.loads(f.read())
    return jsonData


# 创建类型 1 全选属性 其他忽略属性
def 新建一个路径到电影媒体库(库名字: str, 路径: str, 创建类型: int = 1):
    url_encoded_text = urllib.parse.quote(库名字.encode('utf-8'))
    print(url_encoded_text)
    url = f"{server_url}/emby/Library/VirtualFolders?collectionType=movies&refreshLibrary=true&name={url_encoded_text}&api_key={api_key}&X-Emby-Language=zh-cn&reqformat=json"
    # 构建请求体
    jsonData = 读取新建媒体Json(创建类型 == 1 and "新建媒体库全选" or "新建媒体库全忽略")
    jsonData["LibraryOptions"]["PathInfos"][0]["Path"] = 路径
    data = json.dumps(jsonData)
    response = requests.post(
        url,
        json=data,
        verify=False)
    print(f"请求添加媒体库完毕结果：{response}\n库名字:{库名字}\n路径是:{路径}")


def 获取指定名字的媒体库(名字):
    for item in 获取所有的媒体库():
        if item["Name"] == 名字:
            return item


def 获取所有的媒体库():
    url = f"{server_url}/emby/Library/VirtualFolders/Query?api_key={api_key}"
    response = requests.get(url)
    datas = json.loads(response.text)
    # for lib in datas["Items"]:
    #     print(lib["Name"])
    return datas["Items"]


def 刷新媒体库(媒体库名字: str):
    itemId = 获取指定名字的媒体库(媒体库名字)["ItemId"]
    if itemId:
        url = f"{server_url}/emby/Items/{itemId}/Refresh?api_key={api_key}"
        response = requests.post(url)
        print(response)


if __name__ == "__main__":
    for number in range(1, 53):
        新建一个路径到电影媒体库(f"三级电影_{number}", f"/Volumes/dav/影视一/影视/三级电影/max_folder_50G_{number}")
    # for number in range(1, 53):
    #     # 刷新媒体库("三级电影_max_folder_50G_50")
    #     print(number)
    #     刷新媒体库(f"三级电影_max_folder_50G_{number}")
    #     time.sleep(3 * 60 * 60)

# jsonData = 读取新建媒体Json("新建媒体库全选")
# jsonData["LibraryOptions"]["PathInfos"][0]["Path"] = "/mnt/alist/kkkk"
# data = json.dumps(jsonData)
# print(data)
