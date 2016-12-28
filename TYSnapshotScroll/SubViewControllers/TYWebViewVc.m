//
//  TYWebViewVc.m
//  TYSnapshotScroll
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "TYWebViewVc.h"
#import "TYSnapshot.h"

@interface TYWebViewVc ()

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIButton *button;
@end

@implementation TYWebViewVc
-(UIWebView*)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        
        _webView.scalesPageToFit = YES;
        _webView.scrollView.bounces = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void )buttonInit
{
    if (!self.button) {
        CGFloat buttonW = 120;
        CGFloat buttonH = 50;
        CGFloat buttonX = (TYSnapshotMainScreenBounds.size.width - buttonW)/2;
        CGFloat buttonY = TYSnapshotMainScreenBounds.size.height - 2*buttonH;
        CGRect buttonFrame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        
        self.button = [[UIButton alloc] initWithFrame:buttonFrame];
        [self.view addSubview:self.button];
        [self.view bringSubviewToFront:self.button];
        self.button.layer.masksToBounds = YES;
        self.button.layer.cornerRadius = buttonW*0.05;
        self.button.backgroundColor = [UIColor redColor];
        
        
        self.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.button setTitle:@"保存网页为图片" forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(snapshotBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadWebView];
    [self buttonInit];
}

- (void)loadWebView{
    NSString *urlStr = @"https://github.com/TonyReet/TYSnapshotScroll/blob/master/README.md";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];//超时时间5秒
    
    //加载地址数据
    [self.webView loadRequest:request];
}

- (void)snapshotBtn:(UIButton *)sender
{
    [TYSnapshot screenSnapshot:self.webView finishBlock:^(UIImage *snapShotImage) {
        //保存相册
        UIImageWriteToSavedPhotosAlbum(snapShotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        [self.button setTitle:@"保存到相册,请稍后" forState:UIControlStateNormal];
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self.button setTitle:@"保存网页为图片" forState:UIControlStateNormal];
    
    //打印
    if (error == nil) {
        NSLog(@"-------保存成功---------");
    }else{
        NSLog(@"-------保存失败---------");
    }
}
@end
