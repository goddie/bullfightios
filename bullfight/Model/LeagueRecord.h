//
//  LeagueRecord.h
//  bullfight
//
//  Created by goddie on 16/3/1.
//  Copyright © 2016年 santao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface LeagueRecord : BaseModel

/**
 *  <#Description#>
 */
@property (nonatomic, strong) NSString *uuid;


/**
 *  队伍
 */
@property (nonatomic, strong) NSDictionary *team;

/**
 *  胜利
 */
@property (nonatomic, strong) NSNumber *win;

/**
 *  失败
 */
@property (nonatomic, strong) NSNumber *lose;

/**
 *  得分
 */
@property (nonatomic, strong) NSNumber *score;

@end
