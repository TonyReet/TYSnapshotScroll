//
//  UIScrollView+TYSnapshot.m
//  UITableViewSnapshotTest
//
//  Created by Tony on 2016/7/11.
//  Copyright © 2016年 com.9188. All rights reserved.
//

#import "UIScrollView+TYSnapshot.h"
#import "UIImage+TYSnapshot.h"

//打印调试，默认为不打开
static BOOL kTYSnapshotDebugLog = NO;

@implementation UIScrollView (TYSnapshot)

#pragma mark - 设置调试打印
+(void)setTYSnapshotDebugLog:(BOOL )TYSnapshotDebugLog{
    kTYSnapshotDebugLog = TYSnapshotDebugLog;
}

#pragma mark 获取调试打印状态
+(BOOL )getTYSnapshotDebugLog{
    return kTYSnapshotDebugLog;
}

#pragma mark 获取最终拼接完成的图片
+(UIImage *)getSnapshotImage:(UIScrollView *)scrollView{
    //保存截取之前的contentOffset
    CGPoint oldContentOffset = scrollView.contentOffset;

    //截取的图片
    UIImage * snapshotImg = [self screenshot:scrollView];
    
    //还原截取之前的contentOffset
    scrollView.contentOffset = oldContentOffset;
    return snapshotImg;
}


+ (UIImage *)screenshot:(UIScrollView *)scrollView{
    CGSize oldContentSize = scrollView.contentSize;
    
    //截取的快照数组
    NSMutableArray *snapshotList = [NSMutableArray array];
    
    //是否有余数，如果有余数需要增加一个屏幕数
    NSUInteger isRemainder = ((NSUInteger)scrollView.contentSize.height % (NSUInteger)scrollView.bounds.size.height)?1:0;
    
    //计算快照屏幕数
    NSUInteger snapshotScreenCount = scrollView.contentSize.height / scrollView.bounds.size.height + isRemainder;
    
    //先将内容扩大，最后还原
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, snapshotScreenCount * scrollView.bounds.size.height);
    
    //获取所有快照
    for (NSUInteger idx=0; idx< snapshotScreenCount; idx++) {
        UIImage *viewScreenshot;
        CGFloat snapshotHegith = idx*scrollView.bounds.size.height;
        if (idx + 1 == snapshotScreenCount) {
            //最后一屏,需要进行判断，只获取需要的内容
            CGFloat shotSizeHeight = scrollView.bounds.size.height - (scrollView.contentSize.height - oldContentSize.height);
            viewScreenshot = [self screenshotOfViewHeight:snapshotHegith scrollView:scrollView shotSize:CGSizeMake(scrollView.bounds.size.width, shotSizeHeight)];
        }else{
            viewScreenshot = [self screenshotOfViewHeight:snapshotHegith scrollView:scrollView];
        }
        
        if (viewScreenshot) [snapshotList addObject:viewScreenshot];
    }

    scrollView.contentSize = oldContentSize;
    return [UIImage getImageFromImagesArray:snapshotList];
}

#pragma mark - 滑动屏幕并且获取快照
+(UIImage *)screenshotOfViewHeight:(CGFloat )height scrollView:(UIScrollView *)scrollView
{
    if (kTYSnapshotDebugLog) {
        NSLog(@"height  = %@",@(height));
    }
    
    scrollView.contentOffset = CGPointMake(0, height);
    return [self screenShotWithShotView:[scrollView superview]];
}

+(UIImage *)screenshotOfViewHeight:(CGFloat )height scrollView:(UIScrollView *)scrollView shotSize:(CGSize )shotSize
{
    if (kTYSnapshotDebugLog) {
        NSLog(@"height  = %@,shotSize = %@",@(height),NSStringFromCGSize(shotSize));
    }

    scrollView.contentOffset = CGPointMake(0, height);
    return [self screenShotWithShotView:[scrollView superview] shotSize:shotSize];
}

#pragma mark - 获取屏幕快照
+(UIImage *)screenShotWithShotView:(UIView *)shotView
{
    return [self screenShotWithShotView:shotView shotSize:CGSizeZero];
}

+(UIImage *)screenShotWithShotView:(UIView *)shotView shotSize:(CGSize )shotSize
{
    if (shotSize.height == 0|| shotSize.width == 0) {//宽高为0的时候没有意义
        shotSize = shotView.bounds.size;
    }
    
    UIGraphicsBeginImageContext(shotSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [shotView.layer renderInContext:context];
    UIImage *snapshotImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImg;
}
@end
