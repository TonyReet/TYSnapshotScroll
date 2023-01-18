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

    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:[self getViewFrame].origin.y];
    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    [self.view addConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];

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
