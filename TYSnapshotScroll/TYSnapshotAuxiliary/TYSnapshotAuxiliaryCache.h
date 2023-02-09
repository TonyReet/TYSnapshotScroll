//
//  TYSnapshotAuxiliaryCache.h
//  TYSnapshotAuxiliaryCache
//
//  Created by tonyreet on 2020/7/8.
//  Copyright © 2020 TY. All rights reserved.
//

#ifndef TYSnapshotAuxiliaryCache_h
#define TYSnapshotAuxiliaryCache_h
#import <Foundation/Foundation.h>

@interface TYSnapshotAuxiliaryCache : NSObject

+ (NSString *)tya_cacheFileWith:(NSString *)modulePath index:(NSInteger )index;

+ (void )tya_clearCacheWith:(NSString *)modulePath;

@end
#endif /* TYSnapshotDefine_h */
