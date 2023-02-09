//
//  WKWebView+TYSnapshotAuxiliary.h
//  TYSnapshotAuxiliary
//
//  Created by tonyreet on 2020/7/8.
//  Copyright © 2020 TY. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (TYSnapshotAuxiliary)

- (void )getPDFImageWithBlock:(void(^)(UIImage *image))getImageBlock;

@end

NS_ASSUME_NONNULL_END
