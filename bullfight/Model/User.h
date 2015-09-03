//
//  User.h
//  touzimao
//
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface User : BaseModel


@property (nonatomic, strong) NSString *uuid;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *regIp;
@property (nonatomic, strong) NSString *avatar;

/**
 *  昵称
 */
@property (nonatomic, strong) NSString *nickname;
 
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) NSNumber *birthday;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSNumber *scoring;
@property (nonatomic, strong) NSNumber *scoringAvg;
@property (nonatomic, strong) NSNumber *goalPercent;
@property (nonatomic, strong) NSNumber *threeGoal;
@property (nonatomic, strong) NSNumber *threeGoalPercent;
@property (nonatomic, strong) NSNumber *rebound;
@property (nonatomic, strong) NSNumber *assist;
@property (nonatomic, strong) NSNumber *win;
@property (nonatomic, strong) NSNumber *draw;
@property (nonatomic, strong) NSNumber *playCount;
@property (nonatomic, strong) NSNumber *lose;
@property (nonatomic, strong) NSNumber *follows;
@property (nonatomic, strong) NSNumber *fans;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSNumber *block;
@property (nonatomic, strong) NSNumber *steal;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *phone;
@end
