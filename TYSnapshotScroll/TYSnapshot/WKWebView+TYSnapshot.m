//
//  WKWebView+TYSnapshot.m
//  TYSnapshotScroll
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "WKWebView+TYSnapshot.h"

@implementation WKWebView (TYSnapshot)

- (void )screenSnapshot:(void(^)(UIImage *snapShotImage))finishBlock{
    
    //增加一层
    UIView *snapshotView = [self snapshotViewAfterScreenUpdates:YES];
    
    snapshotView.frame = self.frame;
    [self.superview addSubview:snapshotView];
    
    //保存offset
    CGPoint oldOffset = self.scrollView.contentOffset;
    
    //是否有余数，如果有余数需要增加一个屏幕数
    NSUInteger isRemainder = ((NSUInteger)self.scrollView.contentSize.height % (NSUInteger)self.scrollView.bounds.size.height)?1:0;
    
    //计算快照屏幕数
    NSUInteger snapshotScreenCount = self.scrollView.contentSize.height / self.scrollView.bounds.size.height + isRemainder;
    
    UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    
    //截取完所有图片
    [self scrollToDraw:0 maxIndex:(NSInteger )snapshotScreenCount finishBlock:^{
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.scrollView.contentOffset = oldOffset;
        [snapshotView removeFromSuperview];
        
        if (finishBlock) {
            finishBlock(snapshotImage);
        }
    }];
    
}

//滑动画了在截图
- (void )scrollToDraw:(NSInteger )index maxIndex:(NSInteger )maxIndex finishBlock:(void(^)())finishBlock{
    
    self.scrollView.contentOffset = CGPointMake(0, (float)index * self.scrollView.frame.size.height);
    
    //截取的frame
    CGRect snapshotFrame = CGRectMake(0, (float)index * self.scrollView.frame.size.height, self.bounds.size.width, self.bounds.size.height);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        
        [self drawViewHierarchyInRect:snapshotFrame afterScreenUpdates:YES];
        
        if(index < maxIndex){
            [self scrollToDraw:index + 1 maxIndex:maxIndex finishBlock:finishBlock];
        }else{
            if (finishBlock) {
                finishBlock();
            }
        }
    });
}

@end
