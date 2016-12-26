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

/**
 *  最后截图快照
 */
- (UIImage *)screenshot {
    NSMutableArray *screenshots = [NSMutableArray array];
    //表头快照
    UIImage *headerScreenshot = [self screenshotOfHeaderView];
    
    if (headerScreenshot) [screenshots addObject:headerScreenshot];
    
    for (int section=0; section<self.numberOfSections; section++) {
        //区头快照
        UIImage *headerScreenshot = [self screenshotOfHeaderViewAtSection:section];
        if (headerScreenshot) [screenshots addObject:headerScreenshot];
        
        //cell
        for (int row=0; row<[self numberOfRowsInSection:section]; row++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UIImage *cellScreenshot = [self screenshotOfCellAtIndexPath:cellIndexPath];
            if (cellScreenshot) [screenshots addObject:cellScreenshot];
        }
        
        //区尾
        UIImage *footerScreenshot = [self screenshotOfFooterViewAtSection:section];
        if (footerScreenshot) [screenshots addObject:footerScreenshot];
    }
    //表尾
    UIImage *footerScreenshot = [self screenshotOfFooterView];
    if (footerScreenshot) [screenshots addObject:footerScreenshot];
    
    return [UIImage getImageFromImagesArray:screenshots];
}

/**
 *  截取表头
 */
-(UIImage *)screenshotOfHeaderView {
    
    [self beginUpdates];
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self endUpdates];
    
    return [UIScrollView screenShotWithShotView:self.tableHeaderView];
}

/**
 *  截取表尾
 */
-(UIImage *)screenshotOfFooterView {
    return [UIScrollView screenShotWithShotView:self.tableFooterView];
}

/**
 *  截取区头
 */
-(UIImage *)screenshotOfHeaderViewAtSection:(NSInteger)section {
    return [UIScrollView screenShotWithShotView:[self headerViewForSection:section]];
}

/**
 *  截取区尾
 */
-(UIImage *)screenshotOfFooterViewAtSection:(NSInteger)section {
    return [UIScrollView screenShotWithShotView:[self footerViewForSection:section]];
}

/**
 *  截取cell
 */
-(UIImage *)screenshotOfCellAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    
    [self beginUpdates];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self endUpdates];
    
    return [UIScrollView screenShotWithShotView:cell];
}
@end
