//
//  TYSnapshotManager.h
//  TYSnapshotScrollDemo
//
//  Created by TonyReet on 2020/4/30.
//  Copyright © 2020 TonyReet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TYSnapshotType) {
    TYSnapshotTypeDefault = 0,//default
    TYSnapshotTypeSplice,
};

@interface TYSnapshotManager : NSObject

// max count of snapshot,default is 50
@property (nonatomic, assign) NSUInteger maxScreenCount;

// max size of image,default is 4096*4096
@property (nonatomic, assign) NSUInteger maxImageSize;

// delay time,default is 0.3s, unit is second
@property (nonatomic, assign) CGFloat delayTime;

@property (nonatomic, assign) TYSnapshotType snapshotType;

+ (TYSnapshotManager *)defaultManager;


@end

NS_ASSUME_NONNULL_END
