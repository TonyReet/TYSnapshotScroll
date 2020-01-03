//
//  TYViewVC.m
//  TYSnapshotScrollDemo
//
//  Created by TonyReet on 2020/1/3.
//  Copyright © 2020 TonyReet. All rights reserved.
//

#import "TYViewVC.h"

@interface TYViewVC ()

@property (nonatomic,strong) UIView *normalView;

@end

@implementation TYViewVC

- (void)subClassInit {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.normalView = [[UIView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:self.normalView];
    self.normalView.backgroundColor = [UIColor redColor];

    self.snapView = self.normalView;
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    subView.backgroundColor = [UIColor blueColor];
    [self.normalView addSubview:subView];
}

@end
