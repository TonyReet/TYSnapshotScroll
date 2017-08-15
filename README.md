# TYSnapshotScroll
##将scrollView相关的页面保存为图片,支持UIScrollView,UIWebView,UITableView,WKWebView。

[![](https://img.shields.io/badge/Supported-iOS7-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)
[![](https://img.shields.io/badge/Objc-compatible-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)


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


![TYSnapshotScroll](Snapshot.gif)

----------------- 增加长度 start -------------

                     |
                     
                     |
                     
                     |

                     |

                     |

                     |

----------------- 增加长度 end -------------
