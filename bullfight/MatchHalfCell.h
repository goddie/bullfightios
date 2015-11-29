//
//  MatchHalfCell.h
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface MatchHalfCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtPlace;
@property (weak, nonatomic) IBOutlet UILabel *txtDate;
@property (weak, nonatomic) IBOutlet UILabel *txtWeather;
@property (weak, nonatomic) IBOutlet UILabel *txtNum1;
@property (weak, nonatomic) IBOutlet UILabel *txtNum2;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UILabel *txtTeam1;
@property (weak, nonatomic) IBOutlet UILabel *txtTeam2;
@property (weak, nonatomic) IBOutlet UIImageView *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgBot;


@property (nonatomic, strong) NSArray *teamArr;
@end
