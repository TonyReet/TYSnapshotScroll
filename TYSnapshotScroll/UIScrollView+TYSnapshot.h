//
//  UIScrollView+TYSnapshot.h
//  UITableViewSnapshotTest
//
//  Created by Tony on 2016/7/11.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (TYSnapshot)

- (void )screenSnapshot:(void(^)(UIImage *snapShotImage))finishBlock;

/*
/// 截图snapshotView的图片
/// @param snapshotView 需要截取的view
+(UIImage *)screenSnapshotWithSnapshotView:(UIView *)snapshotView;

/// 截图snapshotView的图片,snapshotSize:截取的size
/// @param snapshotView 需要截取的view
/// @param snapshotSize 需要截取的size
+(UIImage *)screenSnapshotWithSnapshotView:(UIView *)snapshotView snapshotSize:(CGSize )snapshotSize;
*/


/// 获取子scrollView的内容的多余高度
/// @param finishBlock 结束回调
- (instancetype )subScrollViewTotalExtraHeight:(void(^)(CGFloat subScrollViewExtraHeight))finishBlock;
@end

