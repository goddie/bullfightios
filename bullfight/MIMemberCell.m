//
//  MIMemberCell.m
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MIMemberCell.h"

@implementation MIMemberCell

- (void)awakeFromNib {
     self.backgroundColor = [UIColor clearColor];
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"shared_avatar_mask_medium.png" point:CGPointMake(70.0f, 70.0f)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
