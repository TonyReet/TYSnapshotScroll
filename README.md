# TYSnapshotScroll


[English](README_EN.md)|简体中文
## 一句代码保存截图,将scrollView相关的页面保存为图片,支持UIScrollView,UITableView,UICollectionView,UIWebView,WKWebView。（支持iOS13）
> Save the scroll view page as an image,support UIScrollView,UITableView,UICollectionView,UIWebView,WKWebView。

[![](https://img.shields.io/badge/Supported-iOS8-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)  [![](https://img.shields.io/badge/Objc-compatible-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)

-------
+ 0.1.9版本已经去掉UIWebView，如果需要使用UIWebView，请使用"版本号-UIWebView"，例如"0.1.9-UIWebView"

+ 修复iOS13ScrollView和WKWebView只能截取一屏的问题，请升级至0.1.4以上版本   

+ 使用真机调试，模拟器测试发现有问题   
-------
### 方法一:cocopods
- 1、:

```objc
在Podfile文件里面添加:pod 'TYSnapshotScroll'
```
- 2、:对应文件添加头文件

```objc
#import "TYSnapshotScroll.h"
```

### 方法二:手动添加
- 1、下载TYSnapshotScroll，将TYSnapshotScroll放到工程中

- 2、引入头文件:

```objc
#import "TYSnapshotScroll.h"
```


### 用法
```objc
//在需要截图的地方调用此方法
[TYSnapshotScroll screenSnapshot:yourView finishBlock:^(UIImage *snapShotImage) {
        // doSomething
    }];
```

正常：   
![TYSnapshotScroll-w240](Snapshot.gif)     

UIScrollView嵌套UITableView：    
![TYSnapshotScroll-w240](Snapshot_1.gif)

2019/11/21:
新增：修复iOS13截图的问题
   
2019/11/04:
新增：UIScrollView嵌套UITableView截图


