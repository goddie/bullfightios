//
//  MFMathInfoCell.h
//  bullfight
//
//  Created by goddie on 15/8/8.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface MFMatchNoticeCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txt1;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
 
@property (weak, nonatomic) IBOutlet UISwitch *sw;

@end
