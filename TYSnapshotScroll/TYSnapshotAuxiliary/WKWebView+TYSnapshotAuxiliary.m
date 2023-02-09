//
//  WKWebView+TYSnapshotAuxiliary.m
//  TYSnapshotAuxiliary
//
//  Created by tonyreet on 2020/7/8.
//  Copyright © 2020 TY. All rights reserved.
//

#import "WKWebView+TYSnapshotAuxiliary.h"
#import "TYSnapshotAuxiliaryPDFTool.h"

@implementation WKWebView (TYSnapshotAuxiliary)

- (void )getPDFImageWithBlock:(void(^)(UIImage *image))getImageBlock{
    NSString *requestUrl = self.URL.absoluteString;
    
    if (![requestUrl hasSuffix:@".pdf"]){
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [TYSnapshotAuxiliaryPDFTool getPDFDataWith:requestUrl finishBlock:getImageBlock];
    });
}
@end
