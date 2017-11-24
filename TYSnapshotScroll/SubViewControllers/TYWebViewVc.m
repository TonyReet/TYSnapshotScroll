//
//  TYWebViewVc.m
//  TYSnapshotScroll
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "TYWebViewVc.h"


@interface TYWebViewVc ()
<
    UIWebViewDelegate
>
@property (nonatomic,strong) UIWebView *webView;

@end

@implementation TYWebViewVc

- (void)subClassInit {
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    NSString *urlStr = @"https://www.meituan.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];//超时时间10秒
    
    //加载地址数据
    [self.webView loadRequest:request];
    
    self.snapView = self.webView;
}

@end
