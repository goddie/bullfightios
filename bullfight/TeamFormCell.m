//
//  TeamFormCell.m
//  bullfight
//
//  Created by goddie on 15/8/21.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TeamFormCell.h"

@implementation TeamFormCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [GlobalConst appBgColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
