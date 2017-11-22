//
//  TYWKWebViewVc.m
//  TYSnapshotScroll
//
//  Created by apple on 16/12/27.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "TYWKWebViewVc.h"

@interface TYWKWebViewVc ()

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation TYWKWebViewVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self wkWebViewInit];
    [self buttonInit:@"保存网页为图片"];
}

- (void)wkWebViewInit{
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    NSString *urlStr = @"https://m.baidu.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];//超时时间5秒
    //加载地址数据
    [self.webView loadRequest:request];
    
    self.snapView = self.webView;
}

@end
