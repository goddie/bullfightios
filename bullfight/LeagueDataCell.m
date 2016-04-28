//
//  LeagueDataCell.m
//  bullfight
//
//  Created by goddie on 16/4/27.
//  Copyright © 2016年 santao. All rights reserved.
//

#import "LeagueDataCell.h"

@implementation LeagueDataCell

- (void)awakeFromNib {
    // Initialization code
     [GlobalUtil setMaskImageQuick:self.img1 withMask:@"shared_avatar_mask_small.png" point:CGPointMake(40.0f, 40.0f)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
