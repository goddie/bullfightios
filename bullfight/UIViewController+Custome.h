//
//  UIViewController+Custome.h
//  bullfight
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginUtil.h"
#import "MBProgressHUD.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface UIViewController (Custome)

- (void)globalConfig;

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success;

-(void)showHud;
-(void)hideHud;

/**
 *  是否登录，没登录去登录
 */
-(NSString*)checkLogin;

/**
 *  隐藏多余分割线
 *
 *  @param tableView <#tableView description#>
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView;
@end
