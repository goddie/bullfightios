//
//  MyTeamCell.m
//  bullfight
//
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MyTeamCell.h"

@implementation MyTeamCell

- (void)awakeFromNib {
    // Initialization code
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(75.0f, 75.0f)];
}

@end
