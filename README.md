# TYSnapshotScroll


English|[简体中文](README_CN.md)
## Save the scroll view page as an image,support UIScrollView,UITableView,UICollectionView,UIWebView,WKWebView.(Support iOS13)

[![](https://img.shields.io/badge/Supported-iOS8-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)  [![](https://img.shields.io/badge/Objc-compatible-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)

- [x] iOS13   
- [x] UITableVieW in UIScrollView     
- [x] UIScrollView
- [x] UITableView
- [x] UICollectionView
- [x] WKWebView
- [x] UIWebView


-------
+ Fix bug on iOS13,please update the lastest version(0.1.4)   

+ Pelease use real machine to debug, simulator has some problems   
-------
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
#import <TYSnapshotScroll.h>
```

- 4、if have error "Undefined symbols for architecture arm64"
add "$(inherited)" into "Other Linker Flags"

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
![TYSnapshotScroll-w240](https://s1.ax1x.com/2020/04/22/JUZHTU.gif)        

UITableView in UIScrollView:    
![TYSnapshotScroll-w240](https://s1.ax1x.com/2020/04/22/JUZSIg.gif)    


