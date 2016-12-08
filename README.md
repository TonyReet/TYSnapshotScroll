# TYSnapshotScroll
##将scrollView相关的页面保存为图片,支持UIScrollView,UITableView,UIWebView,WKWebView。

[![](https://img.shields.io/badge/Supported-iOS7-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)
[![](https://img.shields.io/badge/Objc-compatible-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)


###使用方法
- 1、引入头文件:

```objc
#import "UIScrollView+TYSnapshot.h"
```
- 2、使用以下方法

```objc
[UIScrollView setTYSnapshotDebugLog:YES];
UIImage * snapshotImg = [UIScrollView getSnapshotImage:self.webView.scrollView];
```

**<mark>注意:</mark>**
1、demo里面使用的地址是美团的，美团每页都有个标签，可以换其他网页试试效果更佳

2、方法
```objc
+(UIImage *)getSnapshotImage:(UIScrollView *)scrollView;
```

scrollView为对应的scrollView,比如UIWebView传入webView.scrollView


![TYSnapshotScroll] (https://github.com/TonyReet/TYSnapshotScroll/blob/master/Snapshot.gif)
