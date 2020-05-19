//
//  CustomCollectionViewCell.m
//  TYSnapshotScrollDemo
//
//  Created by TonyReet on 2020/5/8.
//  Copyright © 2020 TonyReet. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:self.textLabel];
        
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
