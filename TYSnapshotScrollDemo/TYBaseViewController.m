//
//  TYBaseViewController.m
//  TYSnapshotScroll
//
//  Created by Tony on 2016/7/11.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYBaseViewController ()

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.navigationController.tabBarItem.title;
    
    self.dataSourceArr = @[
        @{@"TYTableViewVc":@"UITableView_截图"},
        @{@"TYWKWebViewVc":@"WKWebView_截图"},
        @{@"TYScrollViewVc":@"UIScrollView_截图"},
        @{@"TYCollectionViewVc":@"UICollectionView_截图"},
        @{@"TYLayoutScrollViewVc":@"Layout_UIScrollView_截图"},
        @{@"SB_TYScrollEmbedVc":@"SB_ScrollView嵌套TableView_截图"},
        @{@"TYVFLWKWebViewVc":@"Layout_WKWebView_截图"},
        @{@"TYViewVc":@"UIView_截图"},
        @{@"TYTextViewVc":@"UITextView_截图"},
                        ];
    
    [self tableViewInit];
}

-(void )tableViewInit{
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];
    
    NSString *vertical = @"V:|[tableView]|";
    NSString *horizontal = @"H:|[tableView]|";
    NSDictionary *views = @{@"tableView" : self.tableView};
    
    NSArray *verticalLayout = [NSLayoutConstraint constraintsWithVisualFormat:vertical options:0 metrics:nil views:views];
    NSArray *horizontalLayout = [NSLayoutConstraint constraintsWithVisualFormat:horizontal options:0 metrics:nil views:views];
    [self.view addConstraints:verticalLayout];
    [self.view addConstraints:horizontalLayout];
    
    self.tableView.delegate = (id)self;
    self.tableView.dataSource = (id)self;
    self.tableView.backgroundColor = [UIColor whiteColor];

    
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
    NSDictionary *model = (NSDictionary *)self.dataSourceArr[indexPath.row];
    
    cell.textLabel.text = [model.allValues firstObject];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *nextVc;
    
    NSDictionary *model = (NSDictionary *)self.dataSourceArr[indexPath.row];
    NSString *key = [model.allKeys firstObject];
    if ([key containsString:@"SB_"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        nextVc = [storyboard instantiateViewControllerWithIdentifier:[key stringByReplacingOccurrencesOfString:@"SB_" withString:@""]];
    }else{
        nextVc = [NSClassFromString(key) new];
    }

    if (nextVc != nil) {
        NSDictionary *model = (NSDictionary *)self.dataSourceArr[indexPath.row];
        
        nextVc.title = [model.allValues firstObject];
        nextVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nextVc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
