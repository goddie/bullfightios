//
//  TIPositionCell.m
//  bullfight
//  球队阵容
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TIPositionCell.h"

@implementation TIPositionCell

- (void)awakeFromNib {
   [GlobalUtil setMaskImageQuick:self.img1 withMask:@"shared_avatar_mask_small.png" point:CGPointMake(36.0f, 43.0f)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
