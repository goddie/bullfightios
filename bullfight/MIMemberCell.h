//
//  MIMemberCell.h
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UILabel *txtHeight;
@property (weak, nonatomic) IBOutlet UILabel *txtWeight;
@property (weak, nonatomic) IBOutlet UILabel *txtBirthday;
@property (weak, nonatomic) IBOutlet UILabel *txtPos;

@end
