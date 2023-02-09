//
//  TYSnapshotAuxiliaryPDFTool.m
//  PDFToImageDemo
//
//  Created by tonyreet on 2020/7/7.
//  Copyright © 2020 User. All rights reserved.
//

#import "TYSnapshotAuxiliaryPDFTool.h"
#import "TYSpellImage.h"
#import <CommonCrypto/CommonDigest.h>
                                                            
#define KTYDocumentPath ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject])

// 保存文件的路径
#define kTYPDFDownloadPath (@"/TYPDFCache")

@implementation TYSnapshotAuxiliaryPDFTool

+ (void )getPDFDataWith:(NSString *)fileUrl finishBlock:(void(^)(UIImage *image))finishBlock{
    NSString *pDFDownloadPath = [KTYDocumentPath stringByAppendingFormat:@"%@",kTYPDFDownloadPath];
    
    //文件名
    NSString *fileName = [self MD5ForLower32Bate:fileUrl];
    //文件扩展名
    NSString *fileExtension = [fileUrl pathExtension];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@",pDFDownloadPath,fileName,fileExtension];
    
    BOOL isDir;
    // 如果不存在对应目录，直接创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]) {
        [self creatFolderInCacheWithPath:kTYPDFDownloadPath];
    }
    
    NSData *data;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self getPdfImageWithUrl:[NSURL fileURLWithPath:filePath] finishBlock:finishBlock];
        return;
    }
    
    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileUrl]];
    
    BOOL isWrite = [data writeToFile:filePath atomically:YES];
    if (!isWrite) {
        !finishBlock?:finishBlock(nil);
    }
    
    [self getPdfImageWithUrl:[NSURL fileURLWithPath:filePath] finishBlock:finishBlock];
}

+ (void)getPdfImageWithUrl:(NSURL *)fileUrl finishBlock:(void(^)(UIImage *image))finishBlock{
    CGFloat totalHeight = 0;
    
    //获取size
    CGRect rect = CGRectNull;
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)fileUrl);
    
    size_t pageNum = CGPDFDocumentGetNumberOfPages(pdf);
    
    CGRect screenBound = [UIScreen mainScreen].bounds;
    
    NSMutableArray <NSString *>*filesArr = [NSMutableArray new];
    // 画每一页pdf
    for (size_t index = 1; index <= pageNum; index++) {
        @autoreleasepool {
            // 画pdf
            CGPDFPageRef page = CGPDFDocumentGetPage(pdf, index);
            rect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
            NSInteger rotationAngle = CGPDFPageGetRotationAngle(page);
            
            if (rotationAngle == 90 || rotationAngle == 270) {
                CGFloat temp = rect.size.width;
                rect.size.width = rect.size.height;
                rect.size.height = temp;
            }

            CGFloat whRatio = rect.size.height / rect.size.width;
            rect.size.width = screenBound.size.width;
            rect.size.height = rect.size.width * whRatio;
            totalHeight += rect.size.height;
 
            UIImage *image;
            if (!CGRectEqualToRect(rect, CGRectNull)) {
                UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
                CGAffineTransform drawingTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, rect, 0, true);
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                CGContextConcatCTM(ctx, drawingTransform);
                CGContextDrawPDFPage(ctx, page);
                image = UIGraphicsGetImageFromCurrentImageContext();
                image = [UIImage imageWithCGImage:image.CGImage scale:1.0f orientation:UIImageOrientationDownMirrored];
                UIGraphicsEndImageContext();
            }
            

            if (image) {
                NSArray *separatedArr = [fileUrl.absoluteString componentsSeparatedByString:@"."];
                NSString *prefix = [separatedArr firstObject];

                NSString *fileJpgPath = [NSString stringWithFormat:@"%@-%@.jpg",prefix,@(index)];
                NSData *data = UIImageJPEGRepresentation(image, 1.0);
                if (data.length > 0) {
                    NSURL *fileURL = [NSURL URLWithString:fileJpgPath];
                    BOOL isWrite = [data writeToURL:fileURL atomically:YES];
 
                    if (isWrite){
                        [filesArr addObject:fileJpgPath];
                    }
                }
                
                
            }
        }
    }
    
    CGPDFDocumentRelease(pdf);
    
    UIImage *image = [TYSpellImage tya_spellImageOf:CGSizeMake(screenBound.size.width, totalHeight) paths:filesArr];

    dispatch_async(dispatch_get_main_queue(), ^{
        !finishBlock?:finishBlock(image);
        
        // 清除图片缓存
        [filesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:obj] error:nil];
        }];
    });
}

// 清除缓存
+ (void )clearPDFCache{
    [[NSFileManager defaultManager] removeItemAtPath:[KTYDocumentPath stringByAppendingFormat:@"%@",kTYPDFDownloadPath] error:nil];
}

//文件夹创建
+ (void)creatFolderInCacheWithPath:(NSString *)path {
    NSString *creatFolderPath = [KTYDocumentPath stringByAppendingPathComponent:path];
    
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:creatFolderPath isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:creatFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//MD5转换
+ (NSString *)MD5ForLower32Bate:(NSString *)str{
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

@end
