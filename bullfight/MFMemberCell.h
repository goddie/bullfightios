//
//  MFMemberCell.h
//  bullfight
//
//  Created by goddie on 15/8/8.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface MFMemberCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *txtPos;
@property (weak, nonatomic) IBOutlet UILabel *txtName1;

@property (weak, nonatomic) IBOutlet UILabel *txtName2;

@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;

@end
