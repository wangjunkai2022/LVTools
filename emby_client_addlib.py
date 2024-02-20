# -*- coding: utf-8 -*-
import requests
import time
import json

import urllib
# num = 17

# emby服务器的URL和API密钥
server_url = ''
api_key = ''

def 新建一个路径到电影媒体库(库名字: str, 路径: str):
    url_encoded_text = urllib.parse.quote(库名字.encode('utf-8'))
    print(url_encoded_text)
    url = f"{server_url}/emby/Library/VirtualFolders?collectionType=movies&refreshLibrary=true&name={url_encoded_text}&api_key={api_key}&X-Emby-Language=zh-cn&reqformat=json"
    # 构建请求体
    data = {"LibraryOptions":
            {
                "EnableArchiveMediaFiles": "false",
                "EnablePhotos":
                "true",
                "ImportPlaylists": "true",
                "SampleIgnoreSize": "314572800",
                "EnableRealtimeMonitor": "false",
                "ExtractChapterImagesDuringLibraryScan": "false",
                "EnableChapterImageExtraction": "false",
                "EnableMarkerDetectionDuringLibraryScan": "false",
                "EnableMarkerDetection": "false",
                "SaveLocalThumbnailSets": "false",
                "ThumbnailImagesIntervalSeconds": "10",
                "DownloadImagesInAdvance": "false",
                "EnableInternetProviders": "true",
                "ImportMissingEpisodes": "false",
                "SaveLocalMetadata": "false",
                "CacheImages": "false",
                "EnableAutomaticSeriesGrouping": "true",
                "PreferredMetadataLanguage": "",
                "PreferredImageLanguage": "",
                "MetadataCountryCode": "",
                "AutomaticRefreshIntervalDays": "0",
                "PlaceholderMetadataRefreshIntervalDays": "0",
                "EnableEmbeddedTitles": "false",
                "SkipSubtitlesIfEmbeddedSubtitlesPresent": "false",
                "SkipSubtitlesIfAudioTrackMatches": "false",
                "SaveSubtitlesWithMedia": "false",
                "SaveLyricsWithMedia": "true",
                "SubtitleDownloadMaxAgeDays": "0",
                "LyricsDownloadMaxAgeDays": "0",
                "RequirePerfectSubtitleMatch": "true",
                "ForcedSubtitlesOnly": "true",
                "EnableAudioResume": "false",
                "MinResumePct": "3",
                "MaxResumePct": "90",
                "MinResumeDurationSeconds": "120",
                "MusicFolderStructure": "none",
                "ImportCollections": "false",
                "SaveMetadataHidden": "false",
                "EnableAdultMetadata": "false",
                "MinCollectionItems": "2",
                "MetadataSavers": [],
                "TypeOptions": [
                    {
                        "Type": "Movie",
                        "MetadataFetchers": [],
                        "MetadataFetcherOrder": [],
                        "ImageFetchers": [],
                        "ImageFetcherOrder": []
                    }
                ],
                "LocalMetadataReaderOrder": [],
                "SubtitleDownloadLanguages": [],
                "LyricsDownloadLanguages": [],
                "DisabledLocalMetadataReaders": [],
                "DisabledSubtitleFetchers": [],
                "SubtitleFetcherOrder": [],
                "DisabledLyricsFetchers": [],
                "LyricsFetcherOrder": [],
                "PathInfos": [{"Path": 路径}],
                "ContentType": "movies"}}

    
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

    # 新建一个路径到电影媒体库("这是一个测试","/home/ubuntu/")
    for number in range(51, 53):
        # 刷新媒体库("三级电影_max_folder_50G_50")
        print(number)
        刷新媒体库(f"三级电影_max_folder_50G_{number}")
        time.sleep(3*60*60)

