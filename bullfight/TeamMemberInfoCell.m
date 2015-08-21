//
//  TeamMemberInfoCell.m
//  bullfight
//
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TeamMemberInfoCell.h"

@implementation TeamMemberInfoCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"shared_avatar_mask_medium.png" point:CGPointMake(50.0f, 50.0f)];
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_btn_small.png" top:2.0f right:10.0f];
    // Configure the view for the selected state
}

- (IBAction)btn1Click:(id)sender {
    
    
}
@end
