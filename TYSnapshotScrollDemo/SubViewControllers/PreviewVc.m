//
//  PreviewVc.m
//  TYSnapshotScroll
//
//  Created by TonyReet on 2017/11/24.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

#import "PreviewVc.h"

@interface PreviewVc ()

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIImage *image;

@end

@implementation PreviewVc


- (instancetype)init:(UIImage *)image
{
    self = [super init]; //用于初始化父类
    if (self) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self adjustsScrollViewInset];
    
    [self initView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存截图" style:UIBarButtonItemStylePlain target:self action:@selector(saveImage)];
}
- (void)adjustsScrollViewInset{
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [UIImageView new];
    self.imageView.image = self.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.scrollView = [UIScrollView new];
    
    [self.scrollView addSubview:self.imageView];

    [self.view addSubview:self.scrollView];

    CGRect scrollViewFrame = self.view.bounds;
    scrollViewFrame.origin.y = [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.scrollView.frame = scrollViewFrame;
    
    CGFloat height =  self.image.size.height;
    CGFloat width =  self.image.size.width;
    self.scrollView.contentSize = CGSizeMake(width, height);
    self.imageView.frame = CGRectMake(0, 0, width, height);
}

- (void)saveImage{
    //save to photosAlbum
    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *barItemTitle = @"保存成功";
    if (error != nil) {
        barItemTitle = @"保存失败";
    }
    
    [self.navigationItem.rightBarButtonItem setTitle:barItemTitle];
}

@end
