//
//  Commet.m
//  bullfight
//
//  Created by goddie on 15/9/3.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "Commet.h"

@implementation Commet
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uuid":@"id",
             @"matchFight":@"matchFight",
             @"content":@"content",
             @"title":@"title",
             @"from":@"from",
             @"createdDate":@"createdDate",
             @"reply":@"reply",
             @"pic1":@"pic1",
             @"pic1":@"pic2",
             @"pic1":@"pic3",
             @"pic1":@"pic4",
             @"pic1":@"pic5",
             @"pic1":@"pic6"
             
             };
}
@end
