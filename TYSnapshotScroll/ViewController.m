//
//  ViewController.m
//  TYSnapshotScroll
//
//  Created by Tony on 2016/7/11.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+TYSnapshot.h"

@interface ViewController ()
<
    UIWebViewDelegate
>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIButton *button;
@end

@implementation ViewController
-(UIWebView*)webView{
    if (!_webView) {
        CGRect webViewFrame = self.view.bounds;
        webViewFrame.origin.y = 20;
        webViewFrame.size.height -= 20;
        _webView = [[UIWebView alloc] initWithFrame:webViewFrame];
        
        _webView.delegate = (id)self;
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
    NSString *urlStr = @"http://i.meituan.com/";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];//超时时间5秒
    
    //加载地址数据
    [self.webView loadRequest:request];
}

- (void)snapshotBtn:(UIButton *)sender
{

    [UIScrollView setTYSnapshotDebugLog:YES];
    UIImage * snapshotImg = [UIScrollView getSnapshotImage:self.webView.scrollView];
    
    //保存相册
    UIImageWriteToSavedPhotosAlbum(snapshotImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [self.button setTitle:@"保存到相册,请稍后" forState:UIControlStateNormal];
    
    //打印
    if ([UIScrollView getTYSnapshotDebugLog]) {
            NSLog(@"-------保存相册---------");
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self.button setTitle:@"保存网页为图片" forState:UIControlStateNormal];
    
    //打印
    if ([UIScrollView getTYSnapshotDebugLog]) {
        if (error == nil) {
            NSLog(@"-------保存成功---------");
        }else{
            NSLog(@"-------保存失败---------");
        }
    }

}

@end
