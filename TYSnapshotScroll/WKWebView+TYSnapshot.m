//
//  WKWebView+TYSnapshot.m
//  TYSnapshotScroll
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "WKWebView+TYSnapshot.h"
#import "TYGCDTools.h"
#import "UIView+TYSnapshot.h"
#import "TYSnapshotManager.h"
#import "UIScrollView+TYSplice.h"

@implementation WKWebView (TYSnapshot)

- (void )screenSnapshotNeedMask:(BOOL)needMask addMaskAfterBlock:(void(^)(void))addMaskAfterBlock finishBlock:(TYSnapshotFinishBlock )finishBlock{
    if (!finishBlock)return;
    
    UIView *snapshotMaskView;
    if (needMask){
        snapshotMaskView = [self addSnapshotMaskView];
        addMaskAfterBlock?addMaskAfterBlock():nil;
    }
    
    //保存原始信息
    __block CGPoint oldContentOffset;
    __block CGSize contentSize;
    
    __block UIScrollView *scrollView;
    
    onMainThreadSync(^{
        scrollView = self.scrollView;
        
        oldContentOffset = scrollView.contentOffset;
        contentSize = scrollView.contentSize;
        contentSize.height += scrollView.contentInset.top + scrollView.contentInset.bottom;
        scrollView.contentOffset = CGPointZero;
    });
    
    if ([scrollView isBigImageWith:contentSize]){
        [scrollView snapshotBigImageWith:snapshotMaskView contentSize:contentSize oldContentOffset:oldContentOffset finishBlock:finishBlock];
        return ;
    }

    [scrollView snapshotSpliceImageWith:snapshotMaskView contentSize:contentSize oldContentOffset:oldContentOffset finishBlock:finishBlock];
}
@end
