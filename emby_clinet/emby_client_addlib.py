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

if server_url.endswith("/"):
    server_url = server_url[0:-1]


def 读取新建媒体Json(文件名字: str):
    if not 文件名字.endswith("json"):
        文件名字 = f"{文件名字}.json"

    path = os.path.abspath(os.path.dirname(__file__))
    with open(f"{os.path.join(path, 文件名字)}", 'r') as f:
        jsonData = json.loads(f.read())
    return jsonData


def 删除电影库(库id: str):
    url = f"{server_url}/emby/Library/VirtualFolders/Delete?refreshLibrary=true&id={库id}&api_key={api_key}"
    response = requests.post(
        url,
        verify=False)
    if response.status_code == 204:
        print("删除电影库成功")
        return True
    else:
        print("删除电影库失败")
        return False


def 删除所有电影库():
    for lib in 获取所有的媒体库():
        删除电影库(lib["ItemId"])


# 创建类型 1 全选属性 其他忽略属性
def 新建一个路径到电影媒体库(库名字: str, 路径: str, 创建类型: int = 1):
    for 媒体库数据 in 获取所有的媒体库():
        媒体库名字 = 媒体库数据["Name"]
        if 媒体库名字 == 库名字:
            print(f"此媒体库{库名字}已经存在")
            return False
        for 媒体库路径 in 媒体库数据["Locations"]:
            if 媒体库路径 == 路径:
                print(f"此路径:{路径}\n已经添加到:{媒体库名字}")
                return False
    url_encoded_text = urllib.parse.quote(库名字.encode('utf-8'))
    url = f"{server_url}/emby/Library/VirtualFolders?collectionType=movies&refreshLibrary=true&name={url_encoded_text}&api_key={api_key}&X-Emby-Language=zh-cn&reqformat=json"
    # 构建请求体
    json_data = 读取新建媒体Json(创建类型 == 1 and "新建媒体库全选" or "新建媒体库全忽略")
    json_data["LibraryOptions"]["PathInfos"][0]["Path"] = 路径
    response = requests.post(
        url,
        json=json_data,
        verify=False)
    if response.status_code == 204:
        print(f"请求添加媒体库成功：{response}\n库名字:{库名字}\n路径是:{路径}")
        return True
    else:
        print(f"请求添加媒体库失败：{response}\n库名字:{库名字}\n路径是:{路径}")
        return False


def 获取指定名字的媒体库(名字: str):
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
        if response.status_code == 204:
            print("刷新媒体库成功")
            return True
        else:
            print("刷新媒体库失败")
            return False
    else:
        print(f'没有此找到媒体库:{媒体库名字}')


def 获取所有任务():
    url = f'{server_url}/emby/ScheduledTasks?isHidden=false&api_key={api_key}'
    response = requests.get(url)
    datas = json.loads(response.text)
    return datas


def 运行指定任务(任务名字: str = ""):
    task_id = ""
    for task in 获取所有任务():
        if task['State'] == "Cancelling" and (任务名字 in task['Name']):
            task_id = task['Id']
    if len(task_id) == 0:
        print(f"没有找到指定此任务:{任务名字}")
        return
    url = f'{server_url}/emby/ScheduledTasks/Running/{task_id}?api_key={api_key}'
    response = requests.post(url)
    if response.status_code == 204:
        print("运行指定任务成功")
        return True
    else:
        print("运行指定任务失败")
        return False


def 刷新指定任务(任务名字: str = ""):
    task_id = ""
    for task in 获取所有任务():
        if task['State'] == "Cancelling" and (任务名字 in task['Name']):
            task_id = task['Id']
    if len(task_id) == 0:
        print(f"没有找到指定此任务:{任务名字}")
        return
    url = f'{server_url}/emby/ScheduledTasks/Running/{task_id}/Triggers?api_key={api_key}'
    response = requests.post(url)
    if response.status_code == 204:
        print("运行指定任务成功")
        return True
    else:
        print("运行指定任务失败")
        return False


def 停止指定任务(任务名字: str = ""):
    task_id = ""
    for task in 获取所有任务():
        if task['State'] == "Cancelling" and (任务名字 in task['Name']):
            task_id = task['Id']
    if len(task_id) == 0:
        print(f"没有找到指定此任务:{任务名字}")
        return
    url = f'{server_url}/emby/ScheduledTasks/Running/{task_id}/Delete?api_key={api_key}'
    response = requests.post(url)
    if response.status_code == 204:
        print("停止指定任务成功")
        return True
    else:
        print("停止指定任务失败")
        return False


def 判断是否有媒体库在不在等待():
    is_RefreshStatus = False
    for lib in 获取所有的媒体库():
        if lib["RefreshStatus"] != "Idle":
            is_RefreshStatus = True
            break
    return is_RefreshStatus


if __name__ == "__main__":
    # 判断是否有媒体库在不在等待()
    # 获取所有任务()
    # 刷新指定任务("Scan media library")
    # 删除所有电影库()
    for number in range(9, 20):
        if 新建一个路径到电影媒体库(f"三级电影_{number}", f"/mnt/alist/影视一/影视/三级电影/max_folder_50G_{number}", 1):
            time.sleep(5)
            while 判断是否有媒体库在不在等待():
                print("有媒体库在工作")
                time.sleep(60)

# for number in range(1, 53):
#     # 刷新媒体库("三级电影_max_folder_50G_50")
#     print(number)
#     刷新媒体库(f"三级电影_max_folder_50G_{number}")
#     time.sleep(3 * 60 * 60)

# jsonData = 读取新建媒体Json("新建媒体库全选")
# jsonData["LibraryOptions"]["PathInfos"][0]["Path"] = "/mnt/alist/kkkk"
# data = json.dumps(jsonData)
# print(data)
