//
//  UIScrollView+TYSnapshot.m
//  UITableViewSnapshotTest
//
//  Created by Tony on 2016/7/11.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "UIScrollView+TYSnapshot.h"
#import "UIImage+TYSnapshot.h"

@implementation UIScrollView (TYSnapshot)

- (void )screenSnapshot:(void(^)(UIImage *snapShotImage))finishBlock{
    UIImage* snapshotImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.contentSize,NO,0.0);
    
    //保存offset
    CGPoint oldContentOffset = self.contentOffset;
    
    //保存frame
    CGRect oldFrame = self.frame;
    
    self.contentOffset = CGPointZero;
    
    self.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    
    [self.layer renderInContext: UIGraphicsGetCurrentContext()];
    
    snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //还原
    self.contentOffset = oldContentOffset;
    
    self.frame = oldFrame;
    
    UIGraphicsEndImageContext();
    
    if (snapshotImage != nil && finishBlock) {
        finishBlock(snapshotImage);
    }
}

#pragma mark - 获取屏幕快照
+(UIImage *)screenSnapshotWithSnapshotView:(UIView *)snapshotView
{
    return [self screenSnapshotWithSnapshotView:snapshotView snapshotSize:CGSizeZero];
}

+(UIImage *)screenSnapshotWithSnapshotView:(UIView *)snapshotView snapshotSize:(CGSize )snapshotSize
{
    if (snapshotSize.height == 0|| snapshotSize.width == 0) {//宽高为0的时候没有意义
        snapshotSize = snapshotView.bounds.size;
    }
    
    //创建
    UIGraphicsBeginImageContextWithOptions(snapshotSize,NO,0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [snapshotView.layer renderInContext:context];
    
    //获取图片
    UIImage *snapshotImg = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭
    UIGraphicsEndImageContext();
    
    return snapshotImg;
}

- (void )screenWebViewSnapshot:(void(^)(UIImage *snapShotImage))finishBlock{
    
    CGPoint oldContentOffset = self.contentOffset;
    CGSize oldContentSize = self.contentSize;
    
    //截取的快照数组
    NSMutableArray *snapshotList = [NSMutableArray array];
    
    //是否有余数，如果有余数需要增加一个屏幕数
    NSUInteger isRemainder = ((NSUInteger)self.contentSize.height % (NSUInteger)self.bounds.size.height)?1:0;
    
    //计算快照屏幕数
    NSUInteger snapshotScreenCount = self.contentSize.height / self.bounds.size.height + isRemainder;
    
    //先将内容扩大，最后还原
    self.contentSize = CGSizeMake(self.bounds.size.width, snapshotScreenCount * self.bounds.size.height);
    
    //获取所有快照
    for (NSUInteger idx=0; idx< snapshotScreenCount; idx++) {
        UIImage *viewScreenshot;
        CGFloat snapshotHegith = idx*self.bounds.size.height;
        if (idx + 1 == snapshotScreenCount) {
            //最后一屏,需要进行判断，只获取需要的内容
            CGFloat shotSizeHeight = self.bounds.size.height - (self.contentSize.height - oldContentSize.height);
            viewScreenshot = [UIScrollView screenSnapshotOfViewHeight:snapshotHegith scrollView:self snapshotSize:CGSizeMake(self.bounds.size.width, shotSizeHeight)];
        }else{
            viewScreenshot = [UIScrollView screenSnapshotOfViewHeight:snapshotHegith scrollView:self];
        }
        
        if (viewScreenshot) [snapshotList addObject:viewScreenshot];
    }
    
    self.contentOffset = oldContentOffset;
    self.contentSize = oldContentSize;
    
    UIImage *snapshotImage = [UIImage getImageFromImagesArray:snapshotList];
    if (snapshotImage != nil && finishBlock) {
        finishBlock(snapshotImage);
    }
}

#pragma mark - 滑动屏幕并且获取快照
+(UIImage *)screenSnapshotOfViewHeight:(CGFloat )height scrollView:(UIScrollView *)scrollView
{
    scrollView.contentOffset = CGPointMake(0, height);
    
    return [self screenSnapshotWithSnapshotView:[scrollView superview]];
}

+(UIImage *)screenSnapshotOfViewHeight:(CGFloat )height scrollView:(UIScrollView *)scrollView snapshotSize:(CGSize )snapshotSize
{
    scrollView.contentOffset = CGPointMake(0, height);
    
    return [self screenSnapshotWithSnapshotView:[scrollView superview] snapshotSize:snapshotSize];
}

@end
