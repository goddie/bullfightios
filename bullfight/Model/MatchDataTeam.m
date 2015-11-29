//
//  MatchDataTeam.m
//  bullfight
//
//  Created by goddie on 15/9/11.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchDataTeam.h"

@implementation MatchDataTeam
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"uuid",
             @"matchFight":@"matchFight",
             @"team":@"team",
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
             @"turnover":@"turnover",
             @"foul":@"foul"
             
             };
}
@end
