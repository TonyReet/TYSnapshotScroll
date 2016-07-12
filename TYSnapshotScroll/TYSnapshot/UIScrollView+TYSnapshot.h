//
//  UIScrollView+TYSnapshot.h
//  UITableViewSnapshotTest
//
//  Created by Tony on 2016/7/11.
//  Copyright © 2016年 com.9188. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TYSnapshotMainScreenBounds [UIScreen mainScreen].bounds

@interface UIScrollView (TYSnapshot)

/**
 *  调试打印
 *
 *  @param TYSnapshotDebugLog YES:打开打印，NO:关闭打印，默认为关闭
 */
+(void)setTYSnapshotDebugLog:(BOOL )TYSnapshotDebugLog;

/**
 *  获取调试打印状态
 *
 *  @param TYSnapshotDebugLog YES:打开打印，NO:关闭打印，默认为关闭
 */
+(BOOL )getTYSnapshotDebugLog;

/**
 *  获取最终拼接完成的图片
 *
 *  @param scrollView 需要滑动的scrollView
 *
 *  @return 最终获取的图片
 *  
    保存截取图片的方法，再viewController里面调用如下代码
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
 *
 */
+(UIImage *)getSnapshotImage:(UIScrollView *)scrollView;

@end
