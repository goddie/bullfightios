//
//  Team.h
//  bullfight
//
//  Created by goddie on 15/8/19.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Team : BaseModel

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *info;

/**
 * 城市
 */
@property (nonatomic, strong) NSString *city;

/**
 * 头像
 */
@property (nonatomic, strong) NSString *avatar;

/**
 * 管理员
 */
@property (nonatomic, strong) NSDictionary *admin;

/**
 * 状态
 */
@property (nonatomic, strong) NSNumber *status;

/**
 * 得分
 */
@property (nonatomic, strong) NSNumber *scoring;

/**
 * 篮板
 */
@property (nonatomic, strong) NSNumber *rebound;

/**
 * 助攻
 */
@property (nonatomic, strong) NSNumber *assist;

/**
 * 盖帽
 */
@property (nonatomic, strong) NSNumber *block;

/**
 * 抢断
 */
@property (nonatomic, strong) NSNumber *steal;

/**
 * 失误
 */
@property (nonatomic, strong) NSNumber *turnover;

/**
 * 胜利
 */
@property (nonatomic, strong) NSNumber *win;

/**
 * 失败
 */
@property (nonatomic, strong) NSNumber *lose;

/**
 * 平局
 */
@property (nonatomic, strong) NSNumber *draw;

/**
 * 比赛场数
 */
@property (nonatomic, strong) NSNumber *playCount;

/**
 *  成立日期
 */
@property (nonatomic, strong) NSNumber *createdDate;

@end
