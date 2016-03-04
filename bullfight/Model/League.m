//
//  League.m
//  bullfight
//
//  Created by goddie on 16/2/24.
//  Copyright © 2016年 santao. All rights reserved.
//

#import "League.h"

@implementation League

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"name":@"name",
             @"status":@"status",
             @"orderNum":@"orderNum",
             @"teamCount":@"teamCount",
             @"founder":@"founder",
             @"start":@"start",
             @"end":@"end",
             @"arena":@"arena",
             @"avatar":@"avatar",
             @"fee":@"fee",
             @"isOpen":@"isOpen"
             };
}
@end



