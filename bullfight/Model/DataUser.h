//
//  DataUser.h
//  bullfight
//
//  Created by goddie on 16/4/27.
//  Copyright © 2016年 santao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface DataUser : BaseModel

@property (nonatomic, strong) NSNumber *rebound;
@property (nonatomic, strong) NSNumber *assist;
@property (nonatomic, strong) NSNumber *scoring;
@property (nonatomic, strong) NSNumber *plays;
@property (nonatomic, strong) NSNumber *avgrebound;
@property (nonatomic, strong) NSNumber *avgassist;
@property (nonatomic, strong) NSNumber *avgscoring;
@property (nonatomic, strong) NSDictionary *user;

@end
