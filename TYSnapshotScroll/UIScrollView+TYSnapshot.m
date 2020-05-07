//
//  UIScrollView+TYSnapshot.m
//  UITableViewSnapshotTest
//
//  Created by Tony on 2016/7/11.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "UIScrollView+TYSnapshot.h"
#import "UIView+TYSnapshot.h"
#import "TYSnapshotManager.h"
#import <TYSnapshotAuxiliary/UIScrollView+TYSnapshotAuxiliary.h>

@implementation UIScrollView (TYSnapshot)

- (void )screenSnapshotNeedMask:(BOOL)needMask addMaskAfterBlock:(void(^)(void))addMaskAfterBlock finishBlock:(TYSnapshotFinishBlock )finishBlock{
    if (!finishBlock)return;
    
    UIView *snapShotMaskView;
    if (needMask){
        snapShotMaskView = [self addSnapShotMaskView];
        addMaskAfterBlock?addMaskAfterBlock():nil;
    }
    
    //保存offset
    CGPoint oldContentOffset = self.contentOffset;
    
    CGSize contentSize = self.contentSize;
    
    if ([self isBigImageWith:contentSize]){
        [self snapshotBigImageWith:snapShotMaskView contentSize:contentSize oldContentOffset:oldContentOffset finishBlock:finishBlock];
        return ;
    }
    
    [self snapshotNormalImageWith:snapShotMaskView contentSize:contentSize oldContentOffset:oldContentOffset finishBlock:finishBlock];
}

- (BOOL )isBigImageWith:(CGSize )contentSize{
    TYSnapshotManager *snapshotManager = [TYSnapshotManager defaultManager];

    if (contentSize.width * contentSize.height > snapshotManager.maxImageSize){
        return YES;
    }
    
    return NO;
}


- (void )snapshotBigImageWith:(UIView *)snapShotMaskView contentSize:(CGSize )contentSize oldContentOffset:(CGPoint )oldContentOffset finishBlock:(TYSnapshotFinishBlock )finishBlock{
    TYSnapshotManager *snapshotManager = [TYSnapshotManager defaultManager];
    //计算快照屏幕数
    NSUInteger snapshotScreenCount = floorf(contentSize.height / self.bounds.size.height);
    
    __weak typeof(self) weakSelf = self;
    self.contentOffset = CGPointZero;
    
    NSInteger maxScreenCount = snapshotManager.maxScreenCount;
    
    self.delayTime = snapshotManager.delayTime;
    [self screenSnapshotWith:snapshotScreenCount maxScreenCount:maxScreenCount finishBlock:^(UIImage * _Nonnull snapshotImage) {
        
        if (snapShotMaskView.layer){
            [snapShotMaskView.layer removeFromSuperlayer];
        }

        weakSelf.contentOffset = oldContentOffset;
        !finishBlock?:finishBlock(snapshotImage);
        
    }];
}

- (void )snapshotNormalImageWith:(UIView *)snapShotMaskView contentSize:(CGSize )contentSize oldContentOffset:(CGPoint )oldContentOffset finishBlock:(TYSnapshotFinishBlock )finishBlock{
    //保存frame
   CGRect oldFrame = self.frame;

   if (self.contentSize.height > self.frame.size.height) {
       self.contentOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height);
   }
   self.layer.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([TYSnapshotManager defaultManager].delayTime * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
       UIImage* snapshotImage = nil;
       
       self.contentOffset = CGPointZero;

       UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,[UIScreen mainScreen].scale);

       CGContextRef context = UIGraphicsGetCurrentContext();

       [self.layer renderInContext:context];

       snapshotImage = UIGraphicsGetImageFromCurrentImageContext();

       UIGraphicsEndImageContext();

       self.layer.frame = oldFrame;
       //还原
       self.contentOffset = oldContentOffset;
       
       if (snapShotMaskView.layer){
           [snapShotMaskView.layer removeFromSuperlayer];
       }
       
       if (snapshotImage && finishBlock) {
           finishBlock(snapshotImage);
       }
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

