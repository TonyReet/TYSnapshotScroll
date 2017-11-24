//
//  TYSnapshot.m
//  TYSnapshotScroll
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "TYSnapshot.h"
#import "WKWebView+TYSnapshot.h"
#import "UIScrollView+TYSnapshot.h"

@implementation TYSnapshot

+ (void )screenSnapshot:(UIView *)snapshotView finishBlock:(void(^)(UIImage *snapShotImage))finishBlock{
    if ([snapshotView isKindOfClass:[UITableView class]]) {
        //tableview
        UITableView *tableView = (UITableView *)snapshotView;
        
        [tableView screenSnapshot:^(UIImage *snapShotImage) {
            if (snapShotImage != nil && finishBlock) {
                finishBlock(snapShotImage);
            }
        }];
    }else if([snapshotView isKindOfClass:[WKWebView class]]){
        //WKWebView
        WKWebView *wkWebView = (WKWebView *)snapshotView;
        [wkWebView screenSnapshot:^(UIImage *snapShotImage) {
            if (snapShotImage != nil && finishBlock) {
                finishBlock(snapShotImage);
            }
        }];
        
    }else if([snapshotView isKindOfClass:[UIWebView class]]){
        
        //UIWebView
        UIWebView *webView = (UIWebView *)snapshotView;
        
        [webView.scrollView screenSnapshot:^(UIImage *snapShotImage) {
            if (snapShotImage != nil && finishBlock) {
                finishBlock(snapShotImage);
            }
        }];
    }else if([snapshotView isKindOfClass:[UIScrollView class]]){
        //ScrollView
        UIScrollView *scrollView = (UIScrollView *)snapshotView;
        
        [scrollView screenSnapshot:^(UIImage *snapShotImage) {
            if (snapShotImage != nil && finishBlock) {
                finishBlock(snapShotImage);
            }
        }];
    }else{
        NSLog(@"不支持的类型");
    }
}


@end
