//
//  MatchWildCell.m
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchWildCell.h"

@implementation MatchWildCell
{
    UILabel *label;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    
//    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 53.0f, 53.0f)];
//    iv.image = [UIImage imageNamed:@"shared_icon_badge_inactive.png"];
//    self.viewTop.backgroundColor = [UIColor clearColor];
//    [self.viewTop addSubview:iv];
    
    [GlobalUtil set9PathImage:self.imgBot imageName:@"cellBottom.png" top:2.0f right:5.0f];
    
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, 55, 22)];
    label.text  = @"已结束";
    
    [self.viewTop addSubview:label];
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    //label.backgroundColor = [UIColor redColor];
    //rotate label in 45 degrees
    label.transform = CGAffineTransformMakeRotation( M_PI/4 );
    
    
//    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(55.0f, 55.0f)];
//    [GlobalUtil setMaskImageQuick:self.img2 withMask:@"round_mask.png" point:CGPointMake(55.0f, 55.0f)];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCorner:(NSInteger)type
{
    if (type==1) {
        label.text = @"未结束";
        self.viewTop.image = [UIImage imageNamed:@"shared_icon_badge_active.png"];
    }
    
    if (type==0) {
        label.text = @"未结束";
        self.viewTop.image = [UIImage imageNamed:@"shared_icon_badge_active.png"];
    }
    
    if (type==2){
        label.text = @"已结束";
        self.viewTop.image = [UIImage imageNamed:@"shared_icon_badge_inactive.png"];
    }
}

@end
