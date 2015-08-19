//
//  MEMemberCell.m
//  bullfight
//  比赛结束球员数据
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MEMemberCell.h"

@implementation MEMemberCell

- (void)awakeFromNib {
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"shared_avatar_mask_small.png" point:CGPointMake(25.0f, 29.0f)];
    [GlobalUtil setMaskImageQuick:self.img2 withMask:@"shared_avatar_mask_small.png" point:CGPointMake(25.0f, 29.0f)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
