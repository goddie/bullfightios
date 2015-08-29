//
//  MITop.h
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIController.h"


@interface MITop : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;

@property (weak, nonatomic) IBOutlet UIView *teamHolder;


@property (weak, nonatomic) MatchFight *matchFight;

@property (nonatomic, strong) Team *team;

@property (nonatomic, strong) id<TeamTopDelegate> topDelegate;

@property (weak, nonatomic) User *user;

@end
