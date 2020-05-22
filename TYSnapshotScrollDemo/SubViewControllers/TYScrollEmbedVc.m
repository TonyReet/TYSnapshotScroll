//
//  TYScrollEmbedVc.m
//  TYSnapshotScrollDemo
//
//  Created by TonyReet on 2019/11/1.
//  Copyright © 2019 TonyReet. All rights reserved.
//

#import "TYScrollEmbedVc.h"

@interface TYScrollEmbedVc ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutHeight;
@end

@implementation TYScrollEmbedVc


- (void)subClassInit {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.snapView = self.scrollView;

    self.topLabel.text = @"     1、测试UIScrollView和UITableView嵌套截图\n     2、因测试截取图是否正常，故手势冲突没有处理\n     3、嵌套情况，iOS12使用老方法，详细看代码";
    self.tableViewLayoutHeight.constant = self.view.frame.size.height - self.topLabel.frame.size.height;
}

- (void)snapshotBtnClick{
    if (@available(iOS 13.0, *)) {
    //因iOS13在使用AutoLayout的情况下，手动修改contentSize失效，并且因AutoLayout的布局情况太多，不能一一判断你，故相关操作以block处理,iOS12之前用老方法效率高，新方法会有递归
        [self iOS13SnapshotBtnClick];
    } else {
        [super snapshotBtnClick];
    }
}

- (void)iOS13SnapshotBtnClick{
    if (self.snapView != nil){
        [self startAnimating];
        __weak typeof(self) weakSelf = self;

        CGFloat oldTableViewHeight = self.tableViewLayoutHeight.constant;
        
        [TYSnapshotScroll screenSnapshotWithMultipleScroll:self.snapView modifyLayoutBlock:^(CGFloat extraHeight) {
            weakSelf.tableViewLayoutHeight.constant +=extraHeight;
            [weakSelf.view layoutIfNeeded];
        } finishBlock:^(UIImage *snapshotImage) {
            [weakSelf stopAnimating];
            weakSelf.tableViewLayoutHeight.constant = oldTableViewHeight;
            
            [weakSelf pushToPreVcWithImage:snapshotImage];
        }];
    }
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
