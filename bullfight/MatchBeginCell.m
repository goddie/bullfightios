//
//  MatchBeginCell.m
//  bullfight
//
//  Created by goddie on 15/8/4.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchBeginCell.h"

@implementation MatchBeginCell

- (void)awakeFromNib {
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55.0f, 55.0f)];
    iv.image = [UIImage imageNamed:@"shared_icon_badge_active.png"];
    self.viewTop.backgroundColor = [UIColor clearColor];
    [self.viewTop addSubview:iv];
    
    [GlobalUtil set9PathImage:self.imgBot imageName:@"cellBottom.png" top:2.0f right:5.0f];

    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, 55, 22)];
    label.text  = @"未开始";
    
    [self.viewTop addSubview:label];
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    //label.backgroundColor = [UIColor redColor];
    //rotate label in 45 degrees
    label.transform = CGAffineTransformMakeRotation( M_PI/4 );
    
    
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(55.0f, 55.0f)];
    [GlobalUtil setMaskImageQuick:self.img2 withMask:@"round_mask.png" point:CGPointMake(55.0f, 55.0f)];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
