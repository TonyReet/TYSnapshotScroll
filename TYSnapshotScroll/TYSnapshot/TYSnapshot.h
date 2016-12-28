//
//  TYSnapshot.h
//  TYSnapshotScroll
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>

#define TYSnapshotMainScreenBounds [UIScreen mainScreen].bounds

@interface TYSnapshot : NSObject

+ (void )screenSnapshot:(UIView *)snapshotView finishBlock:(void(^)(UIImage *snapShotImage))finishBloc;

@end
