//
//  TYTextViewVc.m
//  TYSnapshotScrollDemo
//
//  Created by TonyReet on 2020/5/22.
//  Copyright © 2020 TonyReet. All rights reserved.
//

#import "TYTextViewVc.h"

@interface TYTextViewVc ()

@property (nonatomic,strong) UITextView *textView;

@end

@implementation TYTextViewVc

- (void)subClassInit {
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];

    NSString *textString = @"";
    NSInteger indexCount = 400;
    for (int index = 0; index < indexCount; index++) {
        textString = [textString stringByAppendingString:[NSString stringWithFormat:@"我是第%@个测试文本,",@(index)]];
    }
    
    self.textView.text = textString;
    
    [self.view addSubview:self.textView];

    self.snapView = self.textView;
}


@end
