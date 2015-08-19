//
//  MatchFutureTop.h
//  bullfight
//
//  Created by goddie on 15/8/8.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFController.h"

@interface MFTop : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UILabel *txtTeam1;
@property (weak, nonatomic) IBOutlet UILabel *txtTeam2;
@property (weak, nonatomic) IBOutlet UILabel *txtNo1;
@property (weak, nonatomic) IBOutlet UILabel *txtNo2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;

@property (weak, nonatomic) MFController *parent;

@end
