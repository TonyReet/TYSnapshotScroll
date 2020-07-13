//
//  TYTextViewInTableViewCell.h
//  TYSnapshotScrollDemo
//
//  Created by tonyreet on 2020/7/13.
//  Copyright © 2020 TonyReet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYTextViewInTableViewCell : UITableViewCell

@property (nonatomic , weak) UITableView *tableView;

- (void)setTVText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
