# TYSnapshotScroll


English|[简体中文](README.md)
## Save the scroll view page as an image,support UIScrollView,UITableView,UICollectionView,UIWebView,WKWebView。

[![](https://img.shields.io/badge/Supported-iOS8-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)
[![](https://img.shields.io/badge/Objc-compatible-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)


### Cocoapods
- 1、Add the following line to your Podfile:

```objc
pod 'TYSnapshotScroll'
```
- 2、Then, run the following command:

```objc
pod install
```

- 3、import .h file:   

```objc    
#import "TYSnapshotScroll.h"
```

### Manually
- 1、download "TYSnapshotScroll"，drag "TYSnapshotScroll" into the project

- 2、import .h file:   :

```objc
#import "TYSnapshotScroll.h"
```



###Usage
```objc
[TYSnapshotScroll screenSnapshot:yourView finishBlock:^(UIImage *snapShotImage) {
        //doSomething
    }];
```

normal:
![TYSnapshotScroll-w240](Snapshot.gif)     

UITableView in UIScrollView:    
![TYSnapshotScroll-w240](Snapshot_1.gif)

2019/11/04:
add：UITableView in UIScrollView
