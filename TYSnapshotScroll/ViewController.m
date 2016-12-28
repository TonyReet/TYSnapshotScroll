//
//  ViewController.m
//  TYSnapshotScroll
//
//  Created by Tony on 2016/7/11.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
<
    UIWebViewDelegate
>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSArray *dataSourceArr;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];


    self.dataSourceArr = @[@"WebView保存为图片",@"tableView保存为图片",@"WKWebView保存为图片"];
    
    [self tableViewInit];
}


-(void )tableViewInit{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    self.tableView.delegate = (id)self;
    self.tableView.dataSource = (id)self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ViewControllerCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataSourceArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *nextVc;
    if (indexPath.row == 0) {
        nextVc = [NSClassFromString(@"TYWebViewVc") new];
        
    }else if(indexPath.row == 1){
        nextVc = [NSClassFromString(@"TYTableViewVc") new];
        
    }else if(indexPath.row == 2){
        nextVc = [NSClassFromString(@"TYWKWebView") new];
        
    }
    
    
    [self.navigationController pushViewController:nextVc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
