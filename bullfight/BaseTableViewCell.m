//
//  BaseTableViewCell.m
//  Bullfight
//
//  Created by goddie on 15/7/25.
//  Copyright (c) 2015年 goddie. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell



-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
 
    
    NSLog(@"awakeFromNib");
    
    return self;
}


- (void)awakeFromNib {
    // Initialization code
    
    for (UIView *currentView in self.subviews)
    {
        if([currentView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
    


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
