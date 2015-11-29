//
//  Message.h
//  bullfight
//
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Message : BaseModel
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSDictionary *matchFight;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDictionary *from;
@property (nonatomic, strong) NSDictionary *sendTo;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *createdDate;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSDictionary *team;
@end
