//
//  TYBaseVc.m
//  TYSnapshotScroll
//
//  Created by TonyReet on 2017/11/22.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

#import "TYBaseVc.h"
#import "PreviewVc.h"
#import "TYSnapshotManager.h"

@interface TYBaseVc ()

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

@end


@implementation TYBaseVc

- (void)viewDidLoad{
    [super viewDidLoad];

    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    //设置小菊花的frame
    self.activityIndicator.frame= CGRectMake(0, 0, 100, 100);
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.color = [UIColor blackColor];
    self.activityIndicator.backgroundColor = [UIColor clearColor];
    self.activityIndicator.hidesWhenStopped = YES;
    
    [self.navigationController.view addSubview:self.activityIndicator];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"截图" style:UIBarButtonItemStylePlain target:self action:@selector(snapshotBtnClick)];
    
    [TYSnapshotManager defaultManager].maxScreenCount = 10;
    [TYSnapshotManager defaultManager].delayTime = 0;
    
    [self subClassInit];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopAnimating];
}

//saveSnap
- (void)snapshotBtnClick{
    if (self.snapView != nil){
        __weak typeof(self) weakSelf = self;
        
        [self startAnimating];
        [TYSnapshotScroll screenSnapshot:self.snapView finishBlock:^(UIImage *snapshotImage) {
            [weakSelf stopAnimating];

            [weakSelf pushToPreVcWithImage:snapshotImage];
        }];

//        /// 另一种调用
//        [TYSnapshotScroll screenSnapshot:self.snapView addMaskAfterBlock:^{
//            [weakSelf startAnimating];
//        } finishBlock:^(UIImage *snapshotImage) {
//            [weakSelf stopAnimating];
//
//            [weakSelf pushToPreVcWithImage:snapshotImage];
//        }];
    }
}

- (void)pushToPreVcWithImage:(UIImage *)snapshotImage{
    UIViewController *preVc = [[PreviewVc alloc] init:snapshotImage];

    [self.navigationController pushViewController:preVc animated:true];
}

- (void)subClassInit{}

- (void)startAnimating{
    if ([self.activityIndicator isAnimating])return;
    
    [self.navigationController.view bringSubviewToFront:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

- (void)stopAnimating{
    if ([self.activityIndicator isAnimating]){
        [self.activityIndicator stopAnimating];
    }
    
}

@end
