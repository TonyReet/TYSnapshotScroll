//
//  TYVFLWKWebViewVc.m
//  TYSnapshotScrollDemo
//
//  Created by TonyReet on 2019/11/18.
//  Copyright © 2019 TonyReet. All rights reserved.
//

#import "TYVFLWKWebViewVc.h"
#import <WebKit/WebKit.h>

@interface TYVFLWKWebViewVc ()
<
    WKNavigationDelegate
>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation TYVFLWKWebViewVc

- (void)subClassInit {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    
    self.webView.navigationDelegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    
    NSString *vertical = @"V:|[webView]|";
    NSString *horizontal = @"H:|[webView]|";
    NSDictionary *views = @{@"webView" : self.webView};
    
    NSArray *verticalLayout = [NSLayoutConstraint constraintsWithVisualFormat:vertical options:0 metrics:nil views:views];
    NSArray *horizontalLayout = [NSLayoutConstraint constraintsWithVisualFormat:horizontal options:0 metrics:nil views:views];

    //一般需要把约束添加到父view上
    [self.view addConstraints:verticalLayout];
    [self.view addConstraints:horizontalLayout];

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
