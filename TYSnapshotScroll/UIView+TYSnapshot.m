//
//  UIView+TYSnapshot.m
//  TYSnapshotScrollDemo
//
//  Created by TonyReet on 2019/3/26.
//  Copyright © 2019 TonyReet. All rights reserved.
//

#import "UIView+TYSnapshot.h"
#import "UIViewController+TYSnapshot.h"

@implementation UIView (TYSnapshot)

- (void )screenSnapshotNeedMask:(BOOL)needMask addMaskAfterBlock:(void(^)(void))addMaskAfterBlock finishBlock:(void(^)(UIImage *snapShotImage))finishBlock{
    if (!finishBlock)return;
    
    UIView *snapShotMaskView;
    if (needMask){
      snapShotMaskView = [self addSnapShotMaskView];
      addMaskAfterBlock?addMaskAfterBlock():nil;
    }
    
    UIImage *snapshotImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,[UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];

    snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (snapShotMaskView){
        [snapShotMaskView removeFromSuperview];
    }

    finishBlock(snapshotImage);
}


- (UIView *)addSnapShotMaskView{
    //获取父view
    UIView *superview;
    UIViewController *currentViewController = [UIViewController currentViewController];
    if (currentViewController){
        superview = currentViewController.view;
    }else{
        superview = self.superview;
    }
    
    //添加遮盖
    UIView *snapShotMaskView = [superview snapshotViewAfterScreenUpdates:YES];
    snapShotMaskView.frame = self.frame;
    
    [superview.layer addSublayer:snapShotMaskView.layer];
    
    return snapShotMaskView;
}
@end
