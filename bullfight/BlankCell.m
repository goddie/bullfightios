//
//  BlankCell.m
//  bullfight
//
//  Created by goddie on 15/9/13.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "BlankCell.h"

@implementation BlankCell

- (void)awakeFromNib {
    // Initialization code
     self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
