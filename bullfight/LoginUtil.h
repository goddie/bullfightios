//
//  LoginUtil.h
//  touzimao
//
//  Created by goddie on 15/8/2.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@interface LoginUtil : NSObject

+(NSString*)getLocalUser;

+(NSString*)getLocalUUID;

+(void)saveLocalUser:(User*)user;

+(void)saveLocalUUID:(User*)user;

+(void)saveUserJSON:(NSDictionary*)userJSON;

+(User*)getUserFromLocalJSON;

+(void)clearLocal;

+(void)addFollowData:(NSString*)uuid;

+(BOOL)hasFollow:(NSString*)uuid;

@end
