//
//  UIScrollView+TYSnapshotAuxiliary.m
//  TYSnapshotAuxiliary
//
//  Created by TonyReet on 2020/4/30.
//  Copyright © 2020 TY. All rights reserved.
//

#import "UIScrollView+TYSnapshotAuxiliary.h"
#import <objc/runtime.h>
#import "TYSpellImage.h"
#import "TYSnapshotAuxiliaryCache.h"

static NSString * const kTYSnapshotAuxiliaryCacheImageNameKey = @"TYSnapshotImage";

@interface UIScrollView ()

@property (nonatomic, strong) NSMutableArray *imageList;

@property (nonatomic, assign) CGFloat screenSnapshotHeihgt;

@end

@implementation UIScrollView (TYSnapshotAuxiliaryCache)

#pragma mark - setter
- (void )setImageList:(NSMutableArray *)imageList{
    objc_setAssociatedObject(self, @selector(imageList), imageList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setScreenSnapshotHeihgt:(CGFloat)screenSnapshotHeihgt{
    objc_setAssociatedObject(self, @selector(screenSnapshotHeihgt), @(screenSnapshotHeihgt), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDelayTime:(CGFloat)delayTime{
    objc_setAssociatedObject(self, @selector(delayTime), @(delayTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - getter
- (NSMutableArray *)imageList{
    NSMutableArray *imageList = objc_getAssociatedObject(self, _cmd);
    return imageList;
}

- (CGFloat)screenSnapshotHeihgt{
    CGFloat screenSnapshotHeihgt = [objc_getAssociatedObject(self, _cmd) floatValue];
    return screenSnapshotHeihgt;
}

- (CGFloat)delayTime{
    CGFloat delayTime = [objc_getAssociatedObject(self, _cmd) floatValue];
    return delayTime;
}


- (void )screenSnapshotWith:(NSInteger )snapshotScreenCount maxScreenCount:(NSInteger )maxScreenCount finishBlock:(void(^)(UIImage *snapshotImage))finishBlock{
    if (!finishBlock)return;

    self.imageList = [[NSMutableArray alloc] init];
    self.screenSnapshotHeihgt = 0;

    if (maxScreenCount){
        snapshotScreenCount = MIN(maxScreenCount, snapshotScreenCount);
    }
        
    //截取完所有图片
    [self tya_scrollToDraw:0 maxIndex:snapshotScreenCount finishBlock:^{
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.screenSnapshotHeihgt);
        
        UIImage *img =  [TYSpellImage tya_spellImageOf:frame.size paths:self.imageList];
    
        // 清楚缓存
        [TYSnapshotAuxiliaryCache tya_clearCacheWith:kTYSnapshotAuxiliaryCacheImageNameKey];
        
        !finishBlock?:finishBlock(img);
    }];
}

- (void )tya_scrollToDraw:(NSInteger )index maxIndex:(NSInteger )maxIndex finishBlock:(void(^)(void))finishBlock{
    @autoreleasepool {
        UIView *snapshotView;
        if (@available(iOS 16.0, *)) {
            snapshotView = self;
        } else {
            snapshotView = self.superview;
        }
            
        CGFloat snapshotY = index * snapshotView.bounds.size.height;
        CGFloat snapshotHeight;
        
        if ( index < maxIndex ){
            snapshotHeight = snapshotView.bounds.size.height;
        }else {
            snapshotHeight = MAX(0, self.contentSize.height - snapshotY);
            snapshotHeight = MIN(snapshotView.bounds.size.height, snapshotHeight);
        }
        
        // 截取的frame
        CGSize snapshotSize = CGSizeMake(snapshotView.bounds.size.width, snapshotHeight);
        CGRect snapshotBounds = CGRectMake(0, 0, snapshotView.bounds.size.width, snapshotView.bounds.size.height);

        [self setContentOffset:CGPointMake(0, snapshotY)];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            UIGraphicsBeginImageContextWithOptions(snapshotSize, NO, [UIScreen mainScreen].scale);
            
            [snapshotView drawViewHierarchyInRect:snapshotBounds afterScreenUpdates:YES];
            
            UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            NSData *imageData =  UIImageJPEGRepresentation(snapshotImage , 1.0);
            NSString *imagePath = [TYSnapshotAuxiliaryCache tya_cacheFileWith:kTYSnapshotAuxiliaryCacheImageNameKey index:index];
            [imageData writeToFile:imagePath atomically:YES];
            
            [self.imageList addObject:imagePath];
            self.screenSnapshotHeihgt += snapshotSize.height;
            
            if(index < maxIndex){
                [self tya_scrollToDraw:index + 1 maxIndex:maxIndex finishBlock:finishBlock];
            }else{
                !finishBlock?:finishBlock();
            }
        });
    }
}

@end
