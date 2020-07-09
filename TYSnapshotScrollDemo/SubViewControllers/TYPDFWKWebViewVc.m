//
//  TYPDFWKWebViewVc.m
//  TYSnapshotScrollDemo
//
//  Created by tonyreet on 2020/7/9.
//  Copyright © 2020 TonyReet. All rights reserved.
//

#import "TYPDFWKWebViewVc.h"
#import <WebKit/WebKit.h>
#import <TYSnapshotAuxiliary/WKWebView+TYSnapshotAuxiliary.h>

@interface TYPDFWKWebViewVc ()
<
    WKNavigationDelegate
>

@property (nonatomic,strong) WKWebView *webView;
@end

@implementation TYPDFWKWebViewVc

- (void)subClassInit {
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    
    self.webView.navigationDelegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];

    //pdf test page (1 page): http://www.orimi.com/pdf-test.pdf
    //pdf test (12 page):https://www.tutorialspoint.com/ios/ios_tutorial.pdf 使用代理比较快
    //pdf test (17 page):https://files.flutter-io.cn/events/gdd2018/Deep_Dive_into_Flutter_Graphics_Performance.pdf 使用代理比较快
    //pdf test (502 page):https://help.adobe.com/archive/zh_CN/acrobat/7/standard/ACROHELP.PDF
    NSString *urlStr = @"http://www.orimi.com/pdf-test.pdf";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:200];//超时时间200秒
    //加载地址数据
    [self.webView loadRequest:request];
    
    [self startAnimating];
}

//saveSnap
- (void)snapshotBtnClick{
    __weak typeof(self) weakSelf = self;
    
    [self startAnimating];
    
    [self.webView getPDFImageWithBlock:^(UIImage * _Nonnull image) {
        [weakSelf stopAnimating];

        [weakSelf pushToPreVcWithImage:image];
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self stopAnimating];
}


@end
