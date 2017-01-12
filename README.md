# TYSnapshotScroll
##将scrollView相关的页面保存为图片,支持UIScrollView,UIWebView,UITableView,WKWebView。

[![](https://img.shields.io/badge/Supported-iOS7-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)
[![](https://img.shields.io/badge/Objc-compatible-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)

**<mark>更新内容:</mark>**

----------------- 2016.12.28更新 -------------

1、修改WKWebView不能截图的问题

2、几种View的布局层次不一致,将各种情况分开处理


----------------- 2016.12.26更新 -------------

1、tableView的图片保存会有问题，最后参考了[ZFBest/UITableViewSnapshot] (https://github.com/ZFBest/UITableViewSnapshot)
对tableview的处理办法暂时解决了，后面有空的话还是会统一逻辑的


----------------- 2016.12.8更新 -------------

1、修改iOS10权限问题

2、修改截图的清晰度，demo地址使用简书地址


###使用方法
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


![TYSnapshotScroll] (https://github.com/TonyReet/TYSnapshotScroll/blob/master/Snapshot.gif)

----------------- 增加长度 -------------

                     |
                     
                     |
                     
                     |
                     
1

                     |
                     
                     |
                     
                     |
                     
2

                     |
                     
                     |
                     
                     |
                     
3

                     |
                     
                     |
                     
                     |
                     
4

                     |
                     
                     |
                     
                     |
                     
5

                     |
                     
                     |
                     
                     |
                     
6

                     |
                     
                     |
                     
                     |
                     
7

                     |
                     
                     |
                     
                     |
                     
8

                     |
                     
                     |
                     
                     |
                     
9

                     |
                     
                     |
                     
                     |
                     
10

                     |
                     
                     |
                     
                     |
                     
11

                     |
                     
                     |
                     
                     |
                     
12

                     |
                     
                     |
                     
                     |
                     
13

                     |
                     
                     |
                     
                     |
                     
14

                     |
                     
                     |
                     
                     |
                     
15

                     |
                     
                     |
                     
                     |
                     
16

                     |
                     
                     |
                     
                     |
                     
17

                     |
                     
                     |
                     
                     |
                     
18

                     |
                     
                     |
                     
                     |
                     
19

                     |
                     
                     |
                     
                     |
                     
20
----------------- 增加长度 -------------
