//
//  UITableView+TYSnapshot.m
//  TableViewShotsTest
//
//  Created by Tony on 2016/12/27.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "UITableView+TYSnapshot.h"
#import "UIImage+TYSnapshot.h"
#import "UIScrollView+TYSnapshot.h"

@implementation UITableView (TYSnapshot)

- (void )screenSnapshot:(void(^)(UIImage *snapShotImage))finishBlock{
    NSMutableArray *screenSnapshots = [NSMutableArray array];
    //表头快照
    UIImage *headerScreenSnapshot = [self screenSnapshotOfHeaderView];
    
    if (headerScreenSnapshot) [screenSnapshots addObject:headerScreenSnapshot];
    
    for (int section=0; section<self.numberOfSections; section++) {
        //区头快照
        UIImage *headerScreenshot = [self screenshotOfHeaderViewAtSection:section];
        if (headerScreenshot) [screenSnapshots addObject:headerScreenshot];
        
        //cell
        for (int row=0; row<[self numberOfRowsInSection:section]; row++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UIImage *cellScreenshot = [self screenSnapshotOfCellAtIndexPath:cellIndexPath];
            if (cellScreenshot) [screenSnapshots addObject:cellScreenshot];
        }
        
        //区尾
        UIImage *footerScreenSnapshotSection = [self screenshotOfFooterViewAtSection:section];
        if (footerScreenSnapshotSection) [screenSnapshots addObject:footerScreenSnapshotSection];
    }
    //表尾
    UIImage *footerScreenSnapshot = [self screenSnapshotOfFooterView];
    if (footerScreenSnapshot) [screenSnapshots addObject:footerScreenSnapshot];
    
    //拼接图片
    if (screenSnapshots.count != 0 && finishBlock) {
        finishBlock([UIImage getImageFromImagesArray:screenSnapshots]);
    }
}

/**
 *  截取表头
 */
-(UIImage *)screenSnapshotOfHeaderView {
    
    [self beginUpdates];
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self endUpdates];
    
    return [UIScrollView screenSnapshotWithSnapshotView:self.tableHeaderView];
}

/**
 *  截取表尾
 */
-(UIImage *)screenSnapshotOfFooterView {
    return [UIScrollView screenSnapshotWithSnapshotView:self.tableFooterView];
}

/**
 *  截取区头
 */
-(UIImage *)screenshotOfHeaderViewAtSection:(NSInteger)section {
    return [UIScrollView screenSnapshotWithSnapshotView:[self headerViewForSection:section]];
}

/**
 *  截取区尾
 */
-(UIImage *)screenshotOfFooterViewAtSection:(NSInteger)section {
    return [UIScrollView screenSnapshotWithSnapshotView:[self footerViewForSection:section]];
}

/**
 *  截取cell
 */
-(UIImage *)screenSnapshotOfCellAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    
    [self beginUpdates];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self endUpdates];
    
    return [UIScrollView screenSnapshotWithSnapshotView:cell];
}
@end
