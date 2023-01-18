//
//  TYViewVc.m
//  TYSnapshotScrollDemo
//
//  Created by TonyReet on 2020/1/3.
//  Copyright © 2020 TonyReet. All rights reserved.
//

#import "TYViewVc.h"

@interface TYViewVc ()

@property (nonatomic,strong) UIView *normalView;

@end

@implementation TYViewVc

- (void)subClassInit {
    self.normalView = [[UIView alloc] initWithFrame:[self getViewFrame]];

    [self.view addSubview:self.normalView];
    self.normalView.backgroundColor = [UIColor redColor];

    self.snapView = self.normalView;
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    subView.backgroundColor = [UIColor blueColor];
    [self.normalView addSubview:subView];
}

@end
