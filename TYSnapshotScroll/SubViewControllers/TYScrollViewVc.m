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

@end

@implementation TYScrollViewVc


- (void)subClassInit {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.scrollView = [[UIScrollView alloc] initWithFrame:screenBounds];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(screenBounds.size.width, screenBounds.size.height*3);
    [self.view addSubview:_scrollView];

    self.snapView = self.scrollView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, self.scrollView.contentSize.height)];
    label.text = @"";
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14.0];
    
    for (int index = 0; index < 400; index++) {
        label.text = [label.text stringByAppendingString:[NSString stringWithFormat:@"我是第%@个测试文本,",@(index)]];
    }
    [self.scrollView addSubview:label];
}
@end
