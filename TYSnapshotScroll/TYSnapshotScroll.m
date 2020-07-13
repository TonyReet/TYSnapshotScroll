//
//  TYSnapshotScroll.m
//  TYSnapshotScroll
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "TYSnapshotScroll.h"
#import "TYGCDTools.h"
#import "WKWebView+TYSnapshot.h"
#import "UIScrollView+TYSnapshot.h"
#import "UIView+TYSnapshot.h"

@implementation TYSnapshotScroll

+ (void )screenSnapshot:(UIView *)snapshotView finishBlock:(void(^)(UIImage *snapshotImage))finishBlock{
    [self screenSnapshot:snapshotView needMask:YES addMaskAfterBlock:nil finishBlock:finishBlock];
}

+ (void )screenSnapshot:(UIView *)snapshotView addMaskAfterBlock:(void(^)(void))addMaskAfterBlock finishBlock:(void(^)(UIImage *snapshotImage))finishBlock{
    BOOL needMask = addMaskAfterBlock?YES:NO;
    [self screenSnapshot:snapshotView needMask:needMask addMaskAfterBlock:addMaskAfterBlock finishBlock:finishBlock];
}

+ (void )screenSnapshot:(UIView *)snapshotView needMask:(BOOL)needMask addMaskAfterBlock:(void(^)(void))addMaskAfterBlock finishBlock:(void(^)(UIImage *snapshotImage))finishBlock{
    UIView *snapshotFinalView = snapshotView;
    
    if([snapshotView isKindOfClass:[WKWebView class]]){
        //WKWebView
        snapshotFinalView = (WKWebView *)snapshotView;
        
    }else if([snapshotView isKindOfClass:[UIScrollView class]] ||
             [snapshotView isKindOfClass:[UITableView class]] ||
             [snapshotView isKindOfClass:[UICollectionView class]]
             ){
        //ScrollView
        snapshotFinalView = (UIScrollView *)snapshotView;
    }else if([snapshotView isKindOfClass:[UIView class]]){
        UIView *uiview = (UIView *)snapshotView;
        snapshotFinalView = uiview;
    }else{
        NSLog(@"不支持的类型");
        
        return;
    }
    
    void(^snapshotBlock)(void) = ^{
        [snapshotFinalView screenSnapshotNeedMask:needMask addMaskAfterBlock:addMaskAfterBlock finishBlock:^(UIImage * _Nonnull snapshotImage) {
            if (!snapshotImage)return;
            
            onMainThreadSync(^{
                !finishBlock?: finishBlock(snapshotImage);
            });
        }];
    };
    
    if([snapshotView isKindOfClass:[UIView class]]){
        //如果是tableView并且是自动算高，需要从上往下依次显示一次，才能得到真正的contentSize
        if ([snapshotView isMemberOfClass:[UITableView class]]){
            UITableView *tableView = (UITableView *)snapshotView;

            if (tableView.rowHeight == UITableViewAutomaticDimension){
                
                CGPoint oldOffset = tableView.contentOffset;
                NSInteger sectionNum = [tableView numberOfSections];
                for (NSInteger indexSection = 0; indexSection < sectionNum; indexSection++){
                    NSInteger rowNum = [tableView numberOfRowsInSection:indexSection];
                    
                    for (NSInteger indexRow = 0; indexRow < rowNum; indexRow++){
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexRow inSection:indexSection];
                        
                        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                }
                
                tableView.contentOffset = oldOffset;
            }
        }
        
        snapshotBlock();
    }else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            snapshotBlock();
        });
    }
}

+(void )screenSnapshotWithMultipleScroll:(UIView *)snapshotView modifyLayoutBlock:(void(^)(CGFloat extraHeight))modifyLayoutBlock finishBlock:(void(^)(UIImage *snapshotImage))finishBlock  {
    [TYSnapshotScroll scrollViewGetTotalExtraHeight:snapshotView finishBlock:^(CGFloat subScrollViewExtraHeight) {
        
        !modifyLayoutBlock?:modifyLayoutBlock(subScrollViewExtraHeight);
        
        [TYSnapshotScroll screenSnapshot:snapshotView finishBlock:^(UIImage *snapshotImage) {
            if (!snapshotImage)return;
            
            onMainThreadSync(^{
                !finishBlock?:finishBlock(snapshotImage);
            });
        }];
    }];
}

+ (void )scrollViewGetTotalExtraHeight:(UIView *)view finishBlock:(void(^)(CGFloat subScrollViewExtraHeight))finishBlock{
    
    if (![view isKindOfClass:[UIScrollView class]]){
        !finishBlock?:finishBlock(0);
        return;
    };
    
    UIScrollView *scrollView = (UIScrollView *)view;
    [scrollView subScrollViewTotalExtraHeight:^(CGFloat subScrollViewExtraHeight) {
        !finishBlock?:finishBlock(subScrollViewExtraHeight);
    }];
}



@end
