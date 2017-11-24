//
//  TYBaseVc.m
//  TYSnapshotScroll
//
//  Created by TonyReet on 2017/11/22.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

#import "TYBaseVc.h"
#import "PreviewVc.h"

@implementation TYBaseVc

- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"截图" style:UIBarButtonItemStylePlain target:self action:@selector(snapshotBtn)];
    
    [self subClassInit];
}

//saveSnap
- (void)snapshotBtn{
    if (self.snapView != nil){
        __weak typeof(self) weakSelf = self;
        [TYSnapshot screenSnapshot:self.snapView finishBlock:^(UIImage *snapShotImage) {
            UIViewController *preVc = [[PreviewVc alloc] init:snapShotImage];

            [weakSelf.navigationController pushViewController:preVc animated:true];
        }];
    }
}

- (void)subClassInit{}


@end
