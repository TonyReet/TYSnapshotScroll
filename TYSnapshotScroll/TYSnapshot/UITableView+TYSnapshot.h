//
//  UITableView+TYSnapshot.h
//  TableViewShotsTest
//
//  Created by Tony on 2016/12/27.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableView (TYSnapshot)

- (void )screenSnapshot:(void(^)(UIImage *snapShotImage))finishBlock;

@end
