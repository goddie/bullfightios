//
//  LeagueRecord.m
//  bullfight
//
//  Created by goddie on 16/3/1.
//  Copyright © 2016年 santao. All rights reserved.
//

#import "LeagueRecord.h"

@implementation LeagueRecord
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"team":@"team",
             @"lose":@"lose",
             @"win":@"win",
             @"score":@"score"
             
             };
}
@end
