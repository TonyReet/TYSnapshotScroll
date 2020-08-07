//
//  UIScrollView+TYSplice.m
//  Pods-TYSnapshotScrollDemo
//
//  Created by tonyreet on 2020/8/5.
//

#import "UIScrollView+TYSplice.h"
#import "TYGCDTools.h"
#import "TYSnapshotManager.h"

@implementation UIScrollView (TYSplice)

- (void )snapshotSpliceImageWith:(UIView *)snapshotMaskView contentSize:(CGSize )contentSize oldContentOffset:(CGPoint )oldContentOffset finishBlock:(TYSnapshotFinishBlock )finishBlock{

    __block CGRect scrollViewBounds;
    onMainThreadSync(^{
       self.contentOffset = CGPointZero;
       scrollViewBounds = self.bounds;
    });

    //计算快照屏幕数
    NSUInteger snapshotScreenCount = floorf(contentSize.height / scrollViewBounds.size.height);

    __weak typeof(self) weakSelf = self;
    UIGraphicsBeginImageContextWithOptions(contentSize, YES, [UIScreen mainScreen].scale);

    //截取完所有图片
    [self scrollToDraw:0 maxIndex:(NSInteger )snapshotScreenCount finishBlock:^{
        if (snapshotMaskView.layer){
            [snapshotMaskView.layer removeFromSuperlayer];
        }

        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        weakSelf.contentOffset = oldContentOffset;
        weakSelf.contentSize = contentSize;
        
        !finishBlock?:finishBlock(snapshotImage);
    }];
}

//滑动画了再截图
- (void )scrollToDraw:(NSInteger )index maxIndex:(NSInteger )maxIndex finishBlock:(void(^)(void))finishBlock{
    __block UIView *snapshotView;
    __block CGRect snapshotFrame;
    onMainThreadAsync(^{
       snapshotView = self.superview;

        //截取的frame
        snapshotFrame = CGRectMake(0, (float)index * snapshotView.bounds.size.height, snapshotView.bounds.size.width, snapshotView.bounds.size.height);

        [self setContentOffset:CGPointMake(0, -self.contentInset.top + index * snapshotView.frame.size.height)];
    });

    CGFloat delayTime = MAX([TYSnapshotManager defaultManager].delayTime, 0.3);
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
