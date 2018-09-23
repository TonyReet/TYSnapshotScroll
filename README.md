# TYSnapshotScroll

## 一句代码保存截图,将scrollView相关的页面保存为图片,支持UIScrollView,UITableView,UICollectionView,UIWebView,WKWebView。支持iOS11

###修改了网页截图类似美团，百度首页截取时下部出现重复显示的问题。

[![](https://img.shields.io/badge/Supported-iOS7-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)
[![](https://img.shields.io/badge/Objc-compatible-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)


### 方法一:cocopods
- 1、:

```objc
在Podfile文件里面添加:pod 'TYSnapshotScroll'
```
- 2、:对应文件添加头文件

```objc
#import "TYSnapshotScroll.h"


//再需要截图的地方调用此方法
[TYSnapshotScroll screenSnapshot:yourView finishBlock:^(UIImage *snapShotImage) {
        doSomething
    }];
```

### 方法二:手动添加
- 1、引入头文件:

```objc
#import "TYSnapshot.h"
```
- 2、使用以下方法

```objc
[TYSnapshotScroll screenSnapshot:yourView finishBlock:^(UIImage *snapShotImage) {
        doSomething
    }];

```


![TYSnapshotScroll](Snapshot.gif)


