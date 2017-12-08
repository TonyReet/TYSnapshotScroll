# TYSnapshotScroll

## 一句代码保存截图,将scrollView相关的页面保存为图片,支持UIScrollView,UIWebView,UITableView,WKWebView。支持iOS11

###修改了网页截图类似美团，百度首页截取时下部出现重复显示的问题。

[![](https://img.shields.io/badge/Supported-iOS7-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)
[![](https://img.shields.io/badge/Objc-compatible-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)


### 使用方法
- 1、引入头文件:

```objc
#import "TYSnapshot.h"
```
- 2、使用以下方法

```objc
[TYSnapshot screenSnapshot:yourView finishBlock:^(UIImage *snapShotImage) {
        doSomething
    }];

```


![TYSnapshotScroll](Snapshot.gif)
