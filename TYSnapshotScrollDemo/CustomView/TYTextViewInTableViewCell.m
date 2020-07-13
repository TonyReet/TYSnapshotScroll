//
//  TYTextViewInTableViewCell.m
//  TYSnapshotScrollDemo
//
//  Created by tonyreet on 2020/7/13.
//  Copyright © 2020 TonyReet. All rights reserved.
//

#import "TYTextViewInTableViewCell.h"

@interface TYTextViewInTableViewCell ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end

@implementation TYTextViewInTableViewCell

- (void)setTVText:(NSString *)text{
    self.textView.text = text;
    
    CGSize size = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX)];
    
    self.textViewHeightConstraint.constant = size.height;

    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

@end
