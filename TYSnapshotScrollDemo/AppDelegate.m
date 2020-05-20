//
//  AppDelegate.m
//  TYSnapshotScroll
//
//  Created by Tony on 2016/7/11.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "AppDelegate.h"
#import "TYBaseViewController.h"
#import "TYLongViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UITabBarController *tabbarVc = [[UITabBarController alloc] init];
    
    TYBaseViewController *baseViewController = [TYBaseViewController new];
    UINavigationController *navigation1 = [[UINavigationController alloc] initWithRootViewController:baseViewController];
    navigation1.tabBarItem.title = @"基本使用";
    navigation1.tabBarItem.image = [UIImage imageNamed:@"screenshot"];
    navigation1.tabBarItem.selectedImage = [UIImage imageNamed:@"screenshot"];
    [tabbarVc addChildViewController:navigation1];
    
    TYLongViewController *longViewController = [TYLongViewController new];
    UINavigationController *navigation2 = [[UINavigationController alloc] initWithRootViewController:longViewController];
    navigation2.tabBarItem.title = @"截取长图";
    navigation2.tabBarItem.image = [UIImage imageNamed:@"screenshotLong"];
    navigation2.tabBarItem.selectedImage = [UIImage imageNamed:@"screenshotLong"];
    
    [tabbarVc addChildViewController:navigation2];

    self.window.rootViewController = tabbarVc;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
