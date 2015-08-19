//
//  User.m
//  touzimao
//
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "User.h"

@implementation User


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"username":@"username",
             @"password":@"password",
             @"email":@"email",
             @"regIp":@"regIp",
             @"nickname":@"nickname",
             @"height":@"height",
             @"weight":@"weight",
             @"birthday":@"birthday",
             @"position":@"position",
             @"scoring":@"scoring",
             @"scoringAvg":@"scoringAvg",
             @"goalPercent":@"goalPercent",
             @"threeGoal":@"threeGoal",
             @"threeGoalPercent":@"threeGoalPercent",
             @"rebound":@"rebound",
             @"assist":@"assist",
             @"win":@"win",
             @"draw":@"draw",
             @"playCount":@"playCount",
             @"lose":@"lose",
             @"follows":@"follows",
             @"fans":@"fans",
             @"city":@"city",
             @"block":@"block",
             @"steal":@"steal"
             };
}


@end

