//
//  Commet.h
//  bullfight
//
//  Created by goddie on 15/9/3.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Commet : BaseModel

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSDictionary *matchFight;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDictionary *from;
@property (nonatomic, strong) NSNumber *createdDate;
@property (nonatomic, strong) NSDictionary *reply;
@property (nonatomic, strong) NSString *pic1;
@property (nonatomic, strong) NSString *pic2;
@property (nonatomic, strong) NSString *pic3;
@property (nonatomic, strong) NSString *pic4;
@property (nonatomic, strong) NSString *pic5;
@property (nonatomic, strong) NSString *pic6;
@end
