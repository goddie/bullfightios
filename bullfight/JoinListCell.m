//
//  JoinListCell.m
//  bullfight
//
//  Created by goddie on 15/8/29.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "JoinListCell.h"

@implementation JoinListCell

- (void)awakeFromNib {
    // Initialization code
    
    [GlobalUtil setMaskImageQuick:self.img withMask:@"shared_avatar_mask_medium.png" point:CGPointMake(44.0f, 44.0f)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
