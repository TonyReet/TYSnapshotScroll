//
//  TYBaseVc.h
//  TYSnapshotScroll
//
//  Created by TonyReet on 2017/11/22.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSnapshotScroll.h"

@interface TYBaseVc : UIViewController

//需要截图的view
@property (nonatomic,strong) UIView *snapView;


/**
 子类初始化方法
 */
- (void)subClassInit;


/**
 菊花转动
 */
- (void)startAnimating;


/**
 菊花停止
 */
- (void)stopAnimating;
@end
