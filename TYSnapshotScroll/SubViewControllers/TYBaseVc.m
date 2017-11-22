//
//  TYBaseVc.m
//  TYSnapshotScroll
//
//  Created by TonyReet on 2017/11/22.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

#import "TYBaseVc.h"

@interface TYBaseVc ()

@end

@implementation TYBaseVc


- (void )buttonInit:(NSString *)title
{
    if (!self.button) {
        CGFloat buttonW = 240;
        CGFloat buttonH = 50;
        CGFloat buttonX = (TYSnapshotMainScreenBounds.size.width - buttonW)/2;
        CGFloat buttonY = TYSnapshotMainScreenBounds.size.height - 2*buttonH;
        CGRect buttonFrame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        
        self.button = [[UIButton alloc] initWithFrame:buttonFrame];
        [self.view addSubview:self.button];
        [self.view bringSubviewToFront:self.button];
        self.button.layer.masksToBounds = YES;
        self.button.layer.cornerRadius = buttonW*0.05;
        self.button.backgroundColor = [UIColor blueColor];
        
        
        self.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.button setTitle:title forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(snapshotBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

//保存图片
- (void)snapshotBtn:(UIButton *)sender
{
    if (self.snapView != nil){
        [self.button setTitle:@"截图中,请稍候" forState:UIControlStateNormal];
        
        [TYSnapshot screenSnapshot:self.snapView finishBlock:^(UIImage *snapShotImage) {
            //保存相册
            UIImageWriteToSavedPhotosAlbum(snapShotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
            [self.button setTitle:@"保存到相册,请稍候" forState:UIControlStateNormal];
        }];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self.button setTitle:@"保存为图片" forState:UIControlStateNormal];
    
    //打印
    if (error == nil) {
        NSLog(@"-------保存成功---------");
    }else{
        NSLog(@"-------保存失败---------");
    }
}

@end
