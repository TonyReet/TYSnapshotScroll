//
//  UIView+TYSnapshot.h
//  TYSnapshotScrollDemo
//
//  Created by TonyReet on 2019/3/26.
//  Copyright © 2019 TonyReet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TYSnapshot)

- (void )screenSnapshotNeedMask:(BOOL)needMask addMaskAfterBlock:(void(^)(void))addMaskAfterBlock finishBlock:(void(^)(UIImage *snapshotImage))finishBlock;

/// 添加当前截图的遮盖
- (UIView *)addSnapshotMaskView;

@end

NS_ASSUME_NONNULL_END
