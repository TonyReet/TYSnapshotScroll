# TYSnapshotScroll
##将scrollView相关的页面保存为图片,支持UIScrollView,UITableView,UIWebView,WKWebView。

###使用方法
1、引入头文件:

```objc
#import "UIScrollView+TYSnapshot.h"
```
2、使用以下方法

```objc
[UIScrollView setTYSnapshotDebugLog:YES];
UIImage * snapshotImg = [UIScrollView getSnapshotImage:self.webView.scrollView];
```

![TYSnapshotScroll] (https://github.com/TonyReet/TYSnapshotScroll/blob/master/Snapshot.gif)
