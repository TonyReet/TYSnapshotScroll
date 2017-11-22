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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableViewInit];
    
    [self buttonInit:@"保存tableview为图片"];
}

-(void )tableViewInit{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    self.tableView.delegate = (id)self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    self.snapView = self.tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
