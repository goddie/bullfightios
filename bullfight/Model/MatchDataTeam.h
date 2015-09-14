//
//  MatchDataTeam.h
//  bullfight
//
//  Created by goddie on 15/9/11.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface MatchDataTeam : BaseModel



@property (nonatomic, strong) NSString *uuid;
/**
 * 比赛
 */
@property (nonatomic, strong) NSDictionary *matchFight;

/**
 * 代表队伍
 */
@property (nonatomic, strong) NSDictionary *team;


/**
 * 得分
 */
@property (nonatomic, strong) NSNumber *scoring;

/**
 * 命中
 */
@property (nonatomic, strong) NSNumber *goal;

/**
 * 出手
 */
@property (nonatomic, strong) NSNumber *shot;

/**
 * 命中率
 */
@property (nonatomic, strong) NSNumber *goalPercent;

/**
 * 三分出手
 */
@property (nonatomic, strong) NSNumber *threeShot;

/**
 * 三分命中
 */
@property (nonatomic, strong) NSNumber *threeGoal;

/**
 * 三分命中率
 */
@property (nonatomic, strong) NSNumber *threeGoalPercent;

/**
 * 罚球
 */
@property (nonatomic, strong) NSNumber *free;

/**
 * 罚球命中
 */
@property (nonatomic, strong) NSNumber *freeGoal;

/**
 * 罚球命中率
 */
@property (nonatomic, strong) NSNumber *freeGoalPercent;

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
 * 犯规次数
 */
@property (nonatomic, strong) NSNumber *foul;
@end
