//
//  TYTableViewVc.m
//  TYSnapshotScroll
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "TYTableViewVc.h"

@interface TYTableViewVc ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TYTableViewVc


- (void)subClassInit {
    CGRect tableViewViewFrame = self.view.bounds;
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    
    tableViewViewFrame.origin.y = statusRect.size.height + navRect.size.height;
    tableViewViewFrame.size.height -= tableViewViewFrame.origin.y;

    self.tableView = [[UITableView alloc] initWithFrame:tableViewViewFrame];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.snapView = self.tableView;
    
    [self adjustsScrollViewInset];
    
    [self.tableView setNeedsDisplay];
}

- (void)adjustsScrollViewInset{
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - delegate 、 datasource
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isLongImage ? 1000 : 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"TYTableViewVcCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"index = %@",@(indexPath.row)];
    
    return cell;
}

@end
