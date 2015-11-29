//
//  Message.m
//  bullfight
//
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "Message.h"

@implementation Message
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"matchFight":@"matchFight",
             @"content":@"content",
             @"title":@"title",
             @"from":@"from",
             @"sendTo":@"sendTo",
             @"status":@"status",
             @"createdDate":@"createdDate",
             @"type":@"type",
             @"team":@"team"
             };
}
@end
