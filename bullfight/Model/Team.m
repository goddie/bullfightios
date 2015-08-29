//
//  Team.m
//  bullfight
//
//  Created by goddie on 15/8/19.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "Team.h"

@implementation Team

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"name":@"name",
             @"info":@"info",
             @"city":@"city",
             @"avatar":@"avatar",
             @"admin":@"admin",
             @"status":@"status",
             @"scoring":@"scoring",
             @"rebound":@"rebound",
             @"assist":@"assist",
             @"block":@"block",
             @"steal":@"steal",
             @"turnover":@"turnover",
             @"win":@"win",
             @"lose":@"lose",
             @"draw":@"draw",
             @"playCount":@"playCount",
             @"createdDate":@"createdDate",
             @"goalPercent":@"goalPercent",
             @"freeGoalPercent":@"freeGoalPercent",
             @"threeGoalPercent":@"threeGoalPercent",
             @"foul":@"foul"
             };
}

@end


