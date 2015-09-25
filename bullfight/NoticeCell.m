//
//  NoticeCell.m
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell

- (void)awakeFromNib {
    // Initialization code
     self.backgroundColor = [UIColor clearColor];
    
    self.txtContent.numberOfLines = 0;
    [self.txtContent sizeToFit];
    
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
