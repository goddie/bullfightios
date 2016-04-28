//
//  DataUser.m
//  bullfight
//
//  Created by goddie on 16/4/27.
//  Copyright © 2016年 santao. All rights reserved.
//

#import "DataUser.h"

@implementation DataUser
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"rebound":@"rebound",
             @"assist":@"assist",
             @"scoring":@"scoring",
             @"plays":@"plays",
             @"avgrebound":@"avgrebound",
             @"avgassist":@"avgassist",
             @"avgscoring":@"avgscoring",
             @"user":@"user"
             
             };
}
@end
