//
//  GlobalConst.m
//  Bullfight
//
//  Created by goddie on 15/6/30.
//  Copyright (c) 2015年 goddie. All rights reserved.
//

#import "GlobalConst.h"

@implementation GlobalConst

NSString *const baseURL = @"http://app.santaotech.com:8080/bullfight/"; //localhost:8080/ 101.200.235.199:8080/  //app.santaotech.com:8080/bullfight/
NSString *const baseURL2 = @"http://app.santaotech.com:8080";
NSString *const appID = @"1015790236";

+(UIColor *)appBgColor
{
    return [UIColor colorWithRed:22.0f/255.0f green:42.0f/255.0f blue:58.0f/255.0f alpha:1.0];
}

+(UIColor*)bottomLineColor
{
    return [UIColor colorWithRed:97.0f/255.0f green:115.0f/255.0f blue:129.0f/255.0f alpha:1.0];
}


+(UIColor*)lightAppBgColor
{
    return [UIColor colorWithRed:34.0f/255.0f green:59.0f/255.0f blue:79.0f/255.0f alpha:1.0];
}

+(UIColor*)tabNormalColor
{
    return [UIColor colorWithRed:114.0f/255.0f green:128.0f/255.0f blue:141.0f/255.0f alpha:1.0];
}


+(UIColor*)tabBgColor
{
    return [UIColor colorWithRed:5.0f/255.0f green:23.0f/255.0f blue:45.0f/255.0f alpha:1.0];
}


+(UIColor*)tabTintColor
{
    return [UIColor colorWithRed:242.0f/255.0f green:78.0f/255.0f blue:43.0f/255.0f alpha:1.0];
}



@end
