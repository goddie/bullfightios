//
//  MFMessageCell.h
//  bullfight
//
//  Created by goddie on 15/8/8.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface MFMessageCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtContent;
@property (weak, nonatomic) IBOutlet UILabel *txtTime;

@end
