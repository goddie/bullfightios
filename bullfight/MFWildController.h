//
//  MFController.h
//  bullfight
//
//  Created by goddie on 15/8/8.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchFight.h"

@interface MFWildController : UITableViewController


-(void)openTeam1;

-(void)switchView:(id)sender;

@property (nonatomic, strong) MatchFight *matchFight;

@end
