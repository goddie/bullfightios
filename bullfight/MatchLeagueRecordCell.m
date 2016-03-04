//
//  MatchLeagueRecordCell.m
//  bullfight
//
//  Created by goddie on 16/2/25.
//  Copyright © 2016年 santao. All rights reserved.
//

#import "MatchLeagueRecordCell.h"

@implementation MatchLeagueRecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(40.0f, 40.0f)];
    // Configure the view for the selected state
}

@end
