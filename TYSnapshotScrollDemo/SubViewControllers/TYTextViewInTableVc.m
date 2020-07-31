//
//  TYTextViewInTableVc.m
//  TYSnapshotScrollDemo
//
//  Created by tonyreet on 2020/7/13.
//  Copyright © 2020 TonyReet. All rights reserved.
//

#import "TYTextViewInTableVc.h"
#import "TYTextViewInTableViewCell.h"

@interface TYTextViewInTableVc ()
<
UITableViewDataSource
>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TYTextViewInTableVc


- (void)subClassInit {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 20;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TYTextViewInTableViewCell" bundle:nil] forCellReuseIdentifier:@"TYTextViewInTableViewCell"];
    
    [self.view addSubview:self.tableView];
    
    self.snapView = self.tableView;
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"TYTextViewInTableViewCell";
    
    TYTextViewInTableViewCell *cell = (TYTextViewInTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[TYTextViewInTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *tvText = [NSString stringWithFormat:@"测试测试0，测试测试1，测试测试2，测试测试3，测试测试4，测试测试5，测试测试6，测试测试7，测试测试8，测试测试9，index:%@",@(indexPath.row)];
    
    cell.textView.text = tvText;

    return cell;
}

@end
