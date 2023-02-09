//
//  TYSnapshotAuxiliaryPDFTool.h
//  PDFToImageDemo
//
//  Created by tonyreet on 2020/7/7.
//  Copyright © 2020 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYSnapshotAuxiliaryPDFTool : NSObject

+ (void )getPDFDataWith:(NSString *)fileUrl finishBlock:(void(^)(UIImage *image))finishBlock;

+ (void )clearPDFCache;

@end

NS_ASSUME_NONNULL_END
