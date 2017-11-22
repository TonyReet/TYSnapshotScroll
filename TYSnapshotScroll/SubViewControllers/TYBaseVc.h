//
//  TYBaseVc.h
//  TYSnapshotScroll
//
//  Created by TonyReet on 2017/11/22.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSnapshot.h"

@interface TYBaseVc : UIViewController

//需要截图的view
@property (nonatomic,strong) UIView *snapView;

@property (nonatomic,strong) UIButton *button;

- (void )buttonInit:(NSString *)title;

//保存图片
- (void)snapshotBtn:(UIButton *)sender;

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end
