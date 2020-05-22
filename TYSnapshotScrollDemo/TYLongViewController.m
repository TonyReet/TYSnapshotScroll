//
//  TYLongViewController.m
//  TYSnapshotScroll
//
//  Created by Tony on 2020/5/7..
//  Copyright © 2020年 TonyReet. All rights reserved.
//

#import "TYLongViewController.h"
#import "TYBaseVc.h"

@implementation TYLongViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSourceArr = @[
        @{@"TYTableViewVc":@"UITableView_长截图"},
        @{@"TYWKWebViewVc":@"WKWebView_长截图"},
        @{@"TYScrollViewVc":@"UIScrollView_长截图"},
        @{@"TYCollectionViewVc":@"UICollectionView_长截图"},
        @{@"TYLayoutScrollViewVc":@"Layout_UIScrollView_长截图"},
        @{@"SB_TYScrollEmbedVc":@"SB_ScrollView嵌套TableView_长截图"},
        @{@"TYVFLWKWebViewVc":@"Layout_WKWebView_长截图"},
                        ];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TYBaseVc *nextVc;
    
    NSDictionary *model = (NSDictionary *)self.dataSourceArr[indexPath.row];
    NSString *key = [model.allKeys firstObject];
    if ([key containsString:@"SB_"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        nextVc = [storyboard instantiateViewControllerWithIdentifier:[key stringByReplacingOccurrencesOfString:@"SB_" withString:@""]];
    }else{
        nextVc = [NSClassFromString(key) new];
    }

    nextVc.isLongImage = YES;
    if (nextVc != nil) {
        NSDictionary *model = (NSDictionary *)self.dataSourceArr[indexPath.row];
        
        nextVc.title = [model.allValues firstObject];
        nextVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nextVc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
