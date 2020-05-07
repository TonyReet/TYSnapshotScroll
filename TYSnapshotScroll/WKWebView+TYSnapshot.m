//
//  WKWebView+TYSnapshot.m
//  TYSnapshotScroll
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "WKWebView+TYSnapshot.h"
#import "UIView+TYSnapshot.h"
#import "TYSnapshotManager.h"
#import <TYSnapshotAuxiliary/UIScrollView+TYSnapshotAuxiliary.h>

@implementation WKWebView (TYSnapshot)

- (void )screenSnapshotNeedMask:(BOOL)needMask addMaskAfterBlock:(void(^)(void))addMaskAfterBlock finishBlock:(TYSnapshotFinishBlock )finishBlock{
    if (!finishBlock)return;
    
    UIView *snapshotMaskView;
    if (needMask){
        snapshotMaskView = [self addSnapshotMaskView];
        addMaskAfterBlock?addMaskAfterBlock():nil;
    }
    
    //保存原始信息
    CGPoint oldContentOffset = self.scrollView.contentOffset;
    CGSize contentSize = self.scrollView.contentSize;
    
    self.scrollView.contentOffset = CGPointZero;
    
    if ([self.scrollView isBigImageWith:contentSize]){
        [self.scrollView snapshotBigImageWith:snapshotMaskView contentSize:contentSize oldContentOffset:oldContentOffset finishBlock:finishBlock];
        return ;
    }

    [self snapshotNormalImageWith:snapshotMaskView contentSize:contentSize oldContentOffset:oldContentOffset finishBlock:finishBlock];
}

- (void )snapshotNormalImageWith:(UIView *)snapshotMaskView contentSize:(CGSize )contentSize oldContentOffset:(CGPoint )oldContentOffset finishBlock:(TYSnapshotFinishBlock )finishBlock{
    
    //计算快照屏幕数
    NSUInteger snapshotScreenCount = floorf(contentSize.height / self.scrollView.bounds.size.height);
    
    __weak typeof(self) weakSelf = self;
    UIGraphicsBeginImageContextWithOptions(contentSize, YES, [UIScreen mainScreen].scale);
    
    //截取完所有图片
    [self scrollToDraw:0 maxIndex:(NSInteger )snapshotScreenCount finishBlock:^{
        if (snapshotMaskView.layer){
            [snapshotMaskView.layer removeFromSuperlayer];
        }
        
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        weakSelf.scrollView.contentOffset = oldContentOffset;
        
        !finishBlock?:finishBlock(snapshotImage);
    }];
}

//滑动画了再截图
- (void )scrollToDraw:(NSInteger )index maxIndex:(NSInteger )maxIndex finishBlock:(void(^)(void))finishBlock{
    UIView *snapshotView = self.superview;
    
    //截取的frame
    CGRect snapshotFrame = CGRectMake(0, (float)index * snapshotView.bounds.size.height, snapshotView.bounds.size.width, snapshotView.bounds.size.height);
    
    [self.scrollView setContentOffset:CGPointMake(0, index * snapshotView.frame.size.height)];

    CGFloat delayTime = [TYSnapshotManager defaultManager].delayTime;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [snapshotView drawViewHierarchyInRect:snapshotFrame afterScreenUpdates:YES];

        if(index < maxIndex){
            [self scrollToDraw:index + 1 maxIndex:maxIndex finishBlock:finishBlock];
        }else{
            !finishBlock?:finishBlock();
        }
    });
}

@end
