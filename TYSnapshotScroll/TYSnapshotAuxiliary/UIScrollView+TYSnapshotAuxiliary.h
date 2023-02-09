//
//  UIScrollView+TYSnapshotAuxiliary.h
//  TYSnapshotAuxiliary
//
//  Created by TonyReet on 2020/4/30.
//  Copyright © 2020 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (TYSnapshotAuxiliary)

@property (nonatomic, assign) CGFloat delayTime;

/// snapshot image
/// @param snapshotScreenCount count of image
/// @param maxScreenCount max count if image too long
/// @param finishBlock finish block
- (void )screenSnapshotWith:(NSInteger )snapshotScreenCount maxScreenCount:(NSInteger )maxScreenCount finishBlock:(void(^)(UIImage *snapshotImage))finishBlock;

@end

NS_ASSUME_NONNULL_END
