//
//  MFMemberCell.m
//  bullfight
//
//  Created by goddie on 15/8/8.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MFMemberCell.h"

@implementation MFMemberCell

- (void)awakeFromNib {
    // Initialization code
    
     self.backgroundColor = [UIColor clearColor];
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"shared_avatar_mask_large.png" point:CGPointMake(65.0f, 65.0f)];
    [GlobalUtil setMaskImageQuick:self.img2 withMask:@"shared_avatar_mask_large.png" point:CGPointMake(65.0f, 65.0f)];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
