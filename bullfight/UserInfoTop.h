//
//  METop.h
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoTop.h"
#import "MEController.h"

@interface UserInfoTop : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UILabel *txtTeam1;
@property (weak, nonatomic) IBOutlet UILabel *txtTeam2;
@property (weak, nonatomic) IBOutlet UILabel *txtNo1;
@property (weak, nonatomic) IBOutlet UILabel *txtNo2;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;

@property (weak, nonatomic) MatchFight *matchFight;
@property (nonatomic, strong) id<TeamTopDelegate> topDelegate;
@property (weak, nonatomic) IBOutlet UILabel *txtScore;

@property (weak, nonatomic) IBOutlet UIView *topHolder;

@end
