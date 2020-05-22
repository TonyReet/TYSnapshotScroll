//
//  TYWKWebViewVc.m
//  TYSnapshotScroll
//
//  Created by apple on 16/12/27.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "TYWKWebViewVc.h"
#import <WebKit/WebKit.h>

@interface TYWKWebViewVc ()
<
    WKNavigationDelegate
>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation TYWKWebViewVc

- (void)subClassInit {
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    
    self.webView.navigationDelegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];

    NSString *urlStr = self.isLongImage?@"https://worlds-highest-website.com/zh/":@"https://www.meituan.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];//超时时间10秒
    //加载地址数据
    [self.webView loadRequest:request];
    
    self.snapView = self.webView;
    [self startAnimating];
    
    [TYSnapshotManager defaultManager].maxScreenCount = 40;
    [TYSnapshotManager defaultManager].delayTime = 0.3;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self stopAnimating];
}

@end
