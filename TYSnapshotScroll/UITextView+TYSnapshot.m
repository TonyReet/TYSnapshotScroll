//
//  UITextView+TYSnapshot.m
//  Pods-TYSnapshotScrollDemo
//
//  Created by TonyReet on 2020/5/22.
//

#import "UITextView+TYSnapshot.h"
#import "TYGCDTools.h"
#import "UIView+TYSnapshot.h"
#import "TYSnapshotManager.h"
#import <TYSnapshotAuxiliary/UIScrollView+TYSnapshotAuxiliary.h>

@implementation UITextView (TYSnapshot)

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
    
    [self snapshotNormalImageWith:snapshotMaskView contentSize:oldContentSize oldContentOffset:oldContentOffset finishBlock:finishBlock];
}

- (BOOL )isBigImageWith:(CGSize )contentSize{
    TYSnapshotManager *snapshotManager = [TYSnapshotManager defaultManager];
    
    if (contentSize.width * contentSize.height > snapshotManager.maxImageSize){
        return YES;
    }
    
    return NO;
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
        
        if (@available(iOS 13.0, *)) {
            [self.attributedText drawInRect:self.layer.frame];
        } else {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [self.layer renderInContext:context];
        }

        snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        //还原
        self.layer.frame = oldFrame;
        self.contentOffset = oldContentOffset;
        
        if (snapshotMaskView.layer){
            [snapshotMaskView.layer removeFromSuperlayer];
        }
        
        !finishBlock?:finishBlock(snapshotImage);
    });
}

@end
