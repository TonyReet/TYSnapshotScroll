//
//  UIViewController+TYSnapshot.m
//  TYSnapshotScroll
//
//  Created by tonyreet on 2018/9/20.
//  Copyright © 2018年 TonyReet. All rights reserved.
//

#import "UIViewController+TYSnapshot.h"

@implementation UIViewController (TYSnapshot)

+ (UIViewController *)currentViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    
    do {
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    } while (vc.presentedViewController);

    return vc;
}

@end
