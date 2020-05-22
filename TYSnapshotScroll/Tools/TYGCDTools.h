//
//  GCDTools.h
//  TYSnapshotScrollDemo
//
//  Created by TonyReet on 2020/5/19.
//  Copyright © 2020 TonyReet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


static inline void onMainThreadAsync(void (^block)(void)) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

static inline void onMainThreadSync(void (^block)(void)) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@interface GCDTools : NSObject


@end

NS_ASSUME_NONNULL_END
