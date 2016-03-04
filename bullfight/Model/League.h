//
//  League.h
//  bullfight
//
//  Created by goddie on 16/2/24.
//  Copyright © 2016年 santao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface League : BaseModel

/**
 * id
 */

@property (nonatomic, strong) NSString *uuid;

/**
 * 名称
 */

@property (nonatomic, strong) NSString *name;

/**
 * 状态
 * 0 未开始 1未结束 2已结束
 */

@property (nonatomic, strong) NSNumber *status;

/**
 * 排序数字
 */

@property (nonatomic, strong) NSNumber *orderNum;

/**
 * 队伍总数
 */

@property (nonatomic, strong) NSNumber *teamCount;

/**
 * 创办人
 */

@property (nonatomic, strong) NSString *founder;

/**
 * 开始时间
 */

@property (nonatomic, strong) NSNumber *start;

/**
 * 结束时间
 */

@property (nonatomic, strong) NSNumber *end;


/**
 * 比赛场馆
 */
@property (nonatomic, strong) NSDictionary *arena;

/**
 * 头像
 */

@property (nonatomic, strong) NSString *avatar;

/**
 * 报名费
 */

@property (nonatomic, strong) NSNumber *fee;

/**
 * 公开报名
 */

@property (nonatomic, strong) NSNumber *isOpen;

@end
