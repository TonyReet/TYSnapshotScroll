//
//  UIScrollView+TYSnapshot.m
//  UITableViewSnapshotTest
//
//  Created by Tony on 2016/7/11.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "UIScrollView+TYSnapshot.h"
#import "UIView+TYSnapshot.h"

@implementation UIScrollView (TYSnapshot)

- (void )screenSnapshotNeedMask:(BOOL)needMask addMaskAfterBlock:(void(^)(void))addMaskAfterBlock finishBlock:(void(^)(UIImage *snapShotImage))finishBlock{
    if (!finishBlock)return;
    
    __block UIImage* snapshotImage = nil;
    
    UIView *snapShotMaskView;
    if (needMask){
        snapShotMaskView = [self addSnapShotMaskView];
        addMaskAfterBlock?addMaskAfterBlock():nil;
    }
    
    //保存offset
    CGPoint oldContentOffset = self.contentOffset;
    //保存frame
    CGRect oldFrame = self.frame;

    if (self.contentSize.height > self.frame.size.height) {
        self.contentOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height);
    }
    self.layer.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);

    //延迟0.3秒，避免有时候渲染不出来的情况
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        self.contentOffset = CGPointZero;


        UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,[UIScreen mainScreen].scale);

        CGContextRef context = UIGraphicsGetCurrentContext();

        [self.layer renderInContext:context];

        //[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];

        snapshotImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        self.layer.frame = oldFrame;
        //还原
        self.contentOffset = oldContentOffset;
        
        if (snapShotMaskView){
            [snapShotMaskView removeFromSuperview];
        }
        
        if (snapshotImage != nil) {
            finishBlock(snapshotImage);
        }
    });
}
                   
/*
#pragma mark - 获取屏幕快照
/// snapshotView:需要截取的view
+(UIImage *)screenSnapshotWithSnapshotView:(UIView *)snapshotView
{
    return [self screenSnapshotWithSnapshotView:snapshotView snapshotSize:CGSizeZero];
}

/// snapshotView:需要截取的view,snapshotSize:需要截取的size
+(UIImage *)screenSnapshotWithSnapshotView:(UIView *)snapshotView snapshotSize:(CGSize )snapshotSize
{
    UIImage *snapshotImg;

    @autoreleasepool{
        if (snapshotSize.height == 0|| snapshotSize.width == 0) {//宽高为0的时候没有意义
            snapshotSize = snapshotView.bounds.size;
        }
        
        //创建
        UIGraphicsBeginImageContextWithOptions(snapshotSize,NO,[UIScreen mainScreen].scale);
        
        CGContextRef context = UIGraphicsGetCurrentContext();

        [snapshotView.layer renderInContext:context];
//        [snapshotView drawViewHierarchyInRect:snapshotView.bounds afterScreenUpdates:NO];
        
        //获取图片
        snapshotImg = UIGraphicsGetImageFromCurrentImageContext();
        
        //关闭
        UIGraphicsEndImageContext();
    }
    return snapshotImg;
}
*/

- (instancetype )subScrollViewTotalExtraHeight:(void(^)(CGFloat subScrollViewExtraHeight))finishBlock{
    __block CGFloat extraHeight = 0.0;
      
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([obj isKindOfClass:[UIScrollView class]]){
          UIScrollView *scrollView = (UIScrollView *)obj;

          if (scrollView.contentSize.height > scrollView.frame.size.height) {
              extraHeight = scrollView.contentSize.height - scrollView.frame.size.height;
          }
          
          [scrollView subScrollViewTotalExtraHeight:^(CGFloat subScrollViewExtraHeight) {
              extraHeight += subScrollViewExtraHeight;
          }];
      }
    }];


    finishBlock?finishBlock(extraHeight):nil;
    return self;
}
@end

