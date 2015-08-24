//
//  MatchFight.m
//  bullfight
//
//  Created by goddie on 15/8/19.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchFight.h"

@implementation MatchFight
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"matchType":@"matchType",
             @"status":@"status",
             @"start":@"start",
             @"end":@"end",
             @"weather":@"weather",
             @"guest":@"guest",
             @"host":@"host",
             @"guestScore":@"guestScore",
             @"hostScore":@"hostScore",
             @"guestMember":@"guestMember",
             @"hostMember":@"hostMember",
             @"teamSize":@"teamSize",
             @"arena":@"arena",
             @"judge":@"judge",
             @"dataRecord":@"dataRecord",
             @"draw":@"draw",
             @"winner":@"winner",
             @"loser":@"loser",
             @"isPay":@"isPay",
             @"fee":@"fee"
             };
}

@end

