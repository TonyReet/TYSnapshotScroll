//
//  UIScrollView+TYSplice.h
//  Pods-TYSnapshotScrollDemo
//
//  Created by tonyreet on 2020/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TYSnapshotFinishBlock)(UIImage *snapshotImage);

@interface UIScrollView (TYSplice)

- (void )snapshotSpliceImageWith:(UIView *)snapshotMaskView contentSize:(CGSize )contentSize oldContentOffset:(CGPoint )oldContentOffset finishBlock:(TYSnapshotFinishBlock )finishBlock;

@end

NS_ASSUME_NONNULL_END
