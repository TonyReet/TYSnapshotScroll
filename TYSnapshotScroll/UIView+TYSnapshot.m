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

- (void )screenSnapshot:(void(^)(UIImage *snapShotImage))finishBlock{
    if (!finishBlock)return;
    
    UIImage *snapshotImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,[UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];

    snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
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
    
    [superview addSubview:snapShotMaskView];
    
    return snapShotMaskView;
}
@end
