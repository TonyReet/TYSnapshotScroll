//
//  TYSpellImage.m
//  TYSnapshotAuxiliary
//
//  Created by tonyreet on 2020/7/8.
//  Copyright © 2020 TY. All rights reserved.
//

#import "TYSpellImage.h"

@implementation TYSpellImage

+ (UIImage *)tya_spellImageOf:(CGSize )imageSize paths:(NSArray <NSString *> *)paths{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
    
    CGFloat drawHeight = 0;
    for (NSInteger index = 0 ;index < paths.count; index++){
        @autoreleasepool {
            NSString *imageName = paths[index];
        
            NSData *imageData = [NSData dataWithContentsOfFile:imageName];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
             if( image == nil ) {
                 imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]];
                 image = [[UIImage alloc] initWithData:imageData];
                 
                 if (!image){
                     NSLog(@"error:input image not found!");
                     break;
                 }
             };
            
            CGFloat imageHeight = image.size.height / [UIScreen mainScreen].scale;
            //Draw masterImage
            [image drawInRect:CGRectMake(0, drawHeight, imageSize.width, imageHeight)];
            drawHeight += imageHeight;
            
            image = nil;
            imageData = nil;
        }
    }
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return resultImage;
}


@end
