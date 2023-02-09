//
//  TYSpellImage.h
//  TYSnapshotAuxiliary
//
//  Created by tonyreet on 2020/7/8.
//  Copyright © 2020 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYSpellImage : NSObject

+ (UIImage *)tya_spellImageOf:(CGSize )imageSize paths:(NSArray <NSString *> *)paths;
    
@end

NS_ASSUME_NONNULL_END
