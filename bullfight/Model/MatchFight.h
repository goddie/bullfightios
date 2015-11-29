//
//  MatchFight.h
//  bullfight
//
//  Created by goddie on 15/8/19.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface MatchFight : BaseModel


@property (nonatomic, strong) NSString *uuid;
/**
 * 1 团队 2野战
 */
@property (nonatomic, strong) NSNumber *matchType;

/**
 * 1 未开始 0待应战 2已结束
 */
@property (nonatomic, strong) NSNumber *status;

/**
 * 开始时间
 */
@property (nonatomic, strong) NSNumber *start;

/**
 * 结束时间
 */
@property (nonatomic, strong) NSNumber *end;
@property (nonatomic, strong) NSString *weather;
@property (nonatomic, strong) NSDictionary *guest;
@property (nonatomic, strong) NSDictionary *host;
@property (nonatomic, strong) NSNumber *guestScore;
@property (nonatomic, strong) NSNumber *hostScore;
@property (nonatomic, strong) NSString *guestMember;
@property (nonatomic, strong) NSString *hostMember;
/**
 * 1 1on1
 * 2 2on2
 * 3 3on3
 * 4 4on4
 * 5 5on5
 */
@property (nonatomic, strong) NSNumber *teamSize;

@property (nonatomic, strong) NSDictionary *arena;

/**
 * 裁判人数
 */
@property (nonatomic, strong) NSNumber *judge;

/**
 * 数据员人数
 */
@property (nonatomic, strong) NSNumber *dataRecord;
/**
 * 是否平局
 */
@property (nonatomic, strong) NSNumber *draw;

/**
 * 胜队
 */
@property (nonatomic, strong) NSDictionary *winner;

/**
 * 败队
 */
@property (nonatomic, strong) NSDictionary *loser;

/**
 * 是否支付
 */
@property (nonatomic, strong) NSNumber *isPay;

/**
 *  比赛费用
 */
@property (nonatomic, strong) NSNumber *fee;

/**
 *  约战说明
 */
@property (nonatomic, strong) NSString *content;

@end
