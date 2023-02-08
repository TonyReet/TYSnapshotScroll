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

    self.tableView = [[UITableView alloc] initWithFrame:[self getViewFrame] style: self.isGroup?UITableViewStyleGrouped:UITableViewStylePlain];

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

- (void)snapshotBtnClick{
    if (self.tableView.style == UITableViewStyleGrouped){
        [self tableViewGroupSnapshot];
        return;
    }
    
    [super snapshotBtnClick];
}

// tableview为group的截图操作
- (void)tableViewGroupSnapshot{
    // 延迟0.5秒，实际延迟时间根据内容配置
    [TYSnapshotManager defaultManager].delayTime = 0.5;
    
    __weak typeof(self) weakSelf = self;
    UITableView *tableView = (UITableView *)self.snapView;

    // 记录数据
    CGRect oldBounds = tableView.bounds;
    CGPoint oldContentOffset = tableView.contentOffset;

    /// 添加遮盖后有操作
    [TYSnapshotScroll screenSnapshot:self.snapView addMaskAfterBlock:^{
        [weakSelf startAnimating];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置bounds，会触发contentSize重新计算
            tableView.contentOffset = oldContentOffset;
            tableView.layer.bounds = CGRectMake(oldBounds.origin.x, oldBounds.origin.y, tableView.contentSize.width, tableView.contentSize.height);
            [tableView layoutIfNeeded];
            
            // 滑动到底部，将cell完全渲染
            [weakSelf scrollTableToBootom:tableView animated:NO];
        });
    } finishBlock:^(UIImage *snapshotImage) {
        // 还原数据
        tableView.bounds = oldBounds;
        tableView.contentOffset = oldContentOffset;
        
        [weakSelf stopAnimating];
        [weakSelf pushToPreVcWithImage:snapshotImage];
    }];
}

#pragma mark  - 滑到最底部
- (void)scrollTableToBootom:(UITableView *)tableView animated:(BOOL)animated
{
    NSInteger sections = [tableView numberOfSections];  //有多少组
    if (sections < 1) return;  //无数据时不执行 要不会crash
    NSInteger row = [tableView numberOfRowsInSection:sections-1]; //最后一组有多少行
    if (row < 1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:row-1 inSection:sections-1];  //取最后一行数据
    [tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}

#pragma mark - delegate 、 datasource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.isGroup)return nil;
    
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"section"];
    if (!headView)
    {
        headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"section"];
    }
    
    headView.contentView.backgroundColor = section%2 ? [UIColor blackColor]:[UIColor whiteColor];
    headView.textLabel.text = [NSString stringWithFormat:@"section %ld", section];
        
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.isGroup ? 80 : 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.isGroup ? 10 : 1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isGroup ? 10 : (self.isLongImage ? 1000 : 100);
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
