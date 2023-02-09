//
//  TYSnapshotAuxiliaryCache.m
//  TYSnapshotAuxiliaryCache
//
//  Created by tonyreet on 2020/7/8.
//  Copyright © 2020 TY. All rights reserved.
//

#import "TYSnapshotAuxiliaryCache.h"

static NSString * const kTYSnapshotAuxiliaryDirectoryNameKey = @"TYSnapshot";

@implementation TYSnapshotAuxiliaryCache

+ (NSString *)tya_cacheFileWith:(NSString *)modulePath index:(NSInteger )index{
    NSString *cacheDirectory = [TYSnapshotAuxiliaryCache tya_getCacheDirWith:modulePath isCreate:YES];
    
    return [cacheDirectory stringByAppendingFormat:@"/%@_%@",modulePath,@(index)];
}


+ (void )tya_clearCacheWith:(NSString *)modulePath{
    // 避免没有删除缓存文件，把目录下的都删除
    NSString *imageDir = [TYSnapshotAuxiliaryCache tya_getCacheDirWith:modulePath isCreate:NO];
    if ([imageDir isEqualToString:@""] || !imageDir ){
        [[NSFileManager defaultManager] removeItemAtPath:imageDir error:nil];
    }
}

+ (NSString *)tya_getCacheDirWith:(NSString *)modulePath isCreate:(BOOL )isCreate{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    
    if (modulePath){
        dir = [NSString stringWithFormat:@"%@%@/%@",dir,kTYSnapshotAuxiliaryDirectoryNameKey,modulePath];
    }else{
        dir = [NSString stringWithFormat:@"%@%@",dir,kTYSnapshotAuxiliaryDirectoryNameKey];
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fm fileExistsAtPath:dir isDirectory:&isDir]) {
        if (!isCreate){
            return @"";
        }
        
        [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL];
        return dir;
    } else {
        // 存在
        return dir;
    }
}

@end
