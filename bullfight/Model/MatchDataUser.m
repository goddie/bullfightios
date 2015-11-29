//
//  MatchDataUser.m
//  bullfight
//
//  Created by goddie on 15/8/22.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchDataUser.h"

@implementation MatchDataUser
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"uuid",
             @"matchFight":@"matchFight",
             @"user":@"user",
             @"team":@"team",
             @"position":@"position",
             @"scoring":@"scoring",
             @"goal":@"goal",
             @"shot":@"shot",
             @"goalPercent":@"goalPercent",
             @"threeShot":@"threeShot",
             @"threeGoal":@"threeGoal",
             @"threeGoalPercent":@"threeGoalPercent",
             @"free":@"free",
             @"freeGoal":@"freeGoal",
             @"freeGoalPercent":@"freeGoalPercent",
             @"rebound":@"rebound",
             @"assist":@"assist",
             @"block":@"block",
             @"steal":@"steal",
             @"playTime":@"playTime",
             @"turnover":@"turnover",
             @"foul":@"foul"
             
             };
}
@end



