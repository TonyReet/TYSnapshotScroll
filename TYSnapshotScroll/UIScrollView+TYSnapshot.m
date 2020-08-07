//
//  UIScrollView+TYSnapshot.m
//  UITableViewSnapshotTest
//
//  Created by Tony on 2016/7/11.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "UIScrollView+TYSnapshot.h"
#import "TYGCDTools.h"
#import "UIView+TYSnapshot.h"
#import "TYSnapshotManager.h"
#import <TYSnapshotAuxiliary/UIScrollView+TYSnapshotAuxiliary.h>

@implementation UIScrollView (TYSnapshot)

- (void )screenSnapshotNeedMask:(BOOL)needMask addMaskAfterBlock:(void(^)(void))addMaskAfterBlock finishBlock:(TYSnapshotFinishBlock )finishBlock{
    if (!finishBlock)return;
    
    UIView *snapshotMaskView;
    if (needMask){
        snapshotMaskView = [self addSnapshotMaskView];
        addMaskAfterBlock?addMaskAfterBlock():nil;
    }
    
    //保存原始信息
    __block CGPoint oldContentOffset;
    __block CGSize oldContentSize;
    
    onMainThreadSync(^{
        oldContentOffset = self.contentOffset;
        oldContentSize = self.contentSize;
    });

    // 异常判断，因为需要根据contentSize截取图片，如果width为0，取自身控件的宽度，结束后还原
    if (!self.contentSize.width){
        NSLog(@"width is zero");
        
        self.contentSize = CGSizeMake(self.bounds.size.width, self.contentSize.height);
    }

    if ([self isBigImageWith:oldContentSize]){
        [self snapshotBigImageWith:snapshotMaskView contentSize:oldContentSize oldContentOffset:oldContentOffset finishBlock:finishBlock];
        return ;
    }
    
    // 使用拼接方案
    if ([TYSnapshotManager defaultManager].snapshotType == TYSnapshotTypeSplice){
        [self snapshotSpliceImageWith:snapshotMaskView contentSize:oldContentSize oldContentOffset:oldContentOffset finishBlock:finishBlock];
        return;
    }
    
    [self snapshotNormalImageWith:snapshotMaskView contentSize:oldContentSize oldContentOffset:oldContentOffset finishBlock:finishBlock];
}

- (BOOL )isBigImageWith:(CGSize )contentSize{
    TYSnapshotManager *snapshotManager = [TYSnapshotManager defaultManager];
    
    if (contentSize.width * contentSize.height > snapshotManager.maxImageSize){
        return YES;
    }
    
    return NO;
}


- (void )snapshotBigImageWith:(UIView *)snapshotMaskView contentSize:(CGSize )contentSize oldContentOffset:(CGPoint )oldContentOffset finishBlock:(TYSnapshotFinishBlock )finishBlock{
    TYSnapshotManager *snapshotManager = [TYSnapshotManager defaultManager];
    //计算快照屏幕数
    NSUInteger snapshotScreenCount = floorf(contentSize.height / self.bounds.size.height);
    
    __weak typeof(self) weakSelf = self;
    self.contentOffset = CGPointZero;
    
    NSInteger maxScreenCount = snapshotManager.maxScreenCount;
    
    self.delayTime = snapshotManager.delayTime;
    [self screenSnapshotWith:snapshotScreenCount maxScreenCount:maxScreenCount finishBlock:^(UIImage * _Nonnull snapshotImage) {
        
        if (snapshotMaskView.layer){
            [snapshotMaskView.layer removeFromSuperlayer];
        }
        
        weakSelf.contentOffset = oldContentOffset;
        weakSelf.contentSize = contentSize;
        
        !finishBlock?:finishBlock(snapshotImage);
    }];
}

- (void )snapshotNormalImageWith:(UIView *)snapshotMaskView contentSize:(CGSize )contentSize oldContentOffset:(CGPoint )oldContentOffset finishBlock:(TYSnapshotFinishBlock )finishBlock{
    //保存frame
    __block CGRect oldFrame;

    onMainThreadSync(^{
        oldFrame = self.layer.frame;
        // 划到bottom
        if (self.contentSize.height > self.frame.size.height) {
            self.contentOffset = CGPointMake(0, self.contentSize.height - self.bounds.size.height + self.contentInset.bottom);
        }

        self.layer.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    });

    CGFloat delayTime = [TYSnapshotManager defaultManager].delayTime;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage* snapshotImage = nil;

        self.contentOffset = CGPointZero;

        UIGraphicsBeginImageContextWithOptions(self.layer.frame.size, NO, [UIScreen mainScreen].scale);

        CGContextRef context = UIGraphicsGetCurrentContext();

        [self.layer renderInContext:context];

        snapshotImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        //还原
        self.layer.frame = oldFrame;
        self.contentOffset = oldContentOffset;
        self.contentSize = contentSize;
        
        if (snapshotMaskView.layer){
            [snapshotMaskView.layer removeFromSuperlayer];
        }

        !finishBlock?:finishBlock(snapshotImage);
    });
}

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

