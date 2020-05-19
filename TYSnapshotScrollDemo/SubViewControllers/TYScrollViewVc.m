//
//  TYScrollViewVc.m
//  TYSnapshotScroll
//
//  Created by TonyReet on 2017/11/22.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

#import "TYScrollViewVc.h"

@interface TYScrollViewVc ()

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *label;

@end

@implementation TYScrollViewVc


- (void)subClassInit {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];

    self.snapView = self.scrollView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    label.text = @"";
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14.0];
    
    NSInteger indexCount = self.isLongImage?4000:400;
    for (int index = 0; index < indexCount; index++) {
        label.text = [label.text stringByAppendingString:[NSString stringWithFormat:@"我是第%@个测试文本,",@(index)]];
    }
    [self.scrollView addSubview:label];
    
    self.label = label;
    
    [self.label sizeToFit];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.label.frame.size.height + 10);
}

@end
