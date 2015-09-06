//
//  MatchWildTop.h
//  bullfight
//
//  Created by goddie on 15/8/28.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchFight.h"
#import "MatchWild.h"

@interface MatchWildTop : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnTotal;
- (IBAction)btnTotalClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnApp;
- (IBAction)btnAppClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *holder;

@property (weak, nonatomic) IBOutlet UIView *topHolder;

@property (weak, nonatomic) MatchFight *matchFight;
@property (nonatomic, strong) id<TeamTopDelegate> topDelegate;

@end
