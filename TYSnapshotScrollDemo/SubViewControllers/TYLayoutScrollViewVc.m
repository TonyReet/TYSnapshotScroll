//
//  TYLayoutScrollViewVc.m
//  TYSnapshotScrollDemo
//
//  Created by TonyReet on 2019/11/19.
//  Copyright © 2019 TonyReet. All rights reserved.
//

#import "TYLayoutScrollViewVc.h"

@interface TYLayoutScrollViewVc ()

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *label;

@end

@implementation TYLayoutScrollViewVc


- (void)subClassInit {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];

    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *vertical = @"V:|[webView]|";
    NSString *horizontal = @"H:|[webView]|";
    NSDictionary *views = @{@"webView" : self.scrollView};

    NSArray *verticalLayout = [NSLayoutConstraint constraintsWithVisualFormat:vertical options:0 metrics:nil views:views];
    NSArray *horizontalLayout = [NSLayoutConstraint constraintsWithVisualFormat:horizontal options:0 metrics:nil views:views];

    //一般需要把约束添加到父view上
    [self.view addConstraints:verticalLayout];
    [self.view addConstraints:horizontalLayout];
    [self.view layoutIfNeeded];
    
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
