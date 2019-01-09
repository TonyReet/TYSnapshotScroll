//
//  TYBaseVc.m
//  TYSnapshotScroll
//
//  Created by TonyReet on 2017/11/22.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

#import "TYBaseVc.h"
#import "PreviewVc.h"

@interface TYBaseVc ()

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

@end


@implementation TYBaseVc

- (void)viewDidLoad{
    [super viewDidLoad];

    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    //设置小菊花的frame
    self.activityIndicator.frame= CGRectMake(0, 0, 100, 100);
    
    [self.view addSubview:self.activityIndicator];

    self.activityIndicator.center = self.view.center;
    
    //设置小菊花颜色
    self.activityIndicator.color = [UIColor blackColor];
    //设置背景颜色
    self.activityIndicator.backgroundColor = [UIColor clearColor];
    
    self.activityIndicator.hidesWhenStopped = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"截图" style:UIBarButtonItemStylePlain target:self action:@selector(snapshotBtn)];
    
    [self subClassInit];
}

//saveSnap
- (void)snapshotBtn{
    if (self.snapView != nil){
        [self startAnimating];
        __weak typeof(self) weakSelf = self;
        [TYSnapshotScroll screenSnapshot:self.snapView finishBlock:^(UIImage *snapShotImage) {
            [weakSelf stopAnimating];
            
            UIViewController *preVc = [[PreviewVc alloc] init:snapShotImage];

            [weakSelf.navigationController pushViewController:preVc animated:true];
        }];
    }
}

- (void)subClassInit{}

- (void)startAnimating{
    if ([self.activityIndicator isAnimating])return;
    
    [self.view bringSubviewToFront:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

- (void)stopAnimating{
    if ([self.activityIndicator isAnimating]){
        [self.activityIndicator stopAnimating];
    }
    
}

@end
