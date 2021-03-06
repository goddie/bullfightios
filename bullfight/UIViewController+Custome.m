//
//  UIViewController+Custome.m
//  bullfight
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "UIViewController+Custome.h"


#import "AFNetworking.h"
#import "MTLJSONAdapter.h"
#import "User.h"
#import "LoginUtil.h"
#import "HttpUtil.h"
#import "AppDelegate.h"


@implementation UIViewController (Custome)

MBProgressHUD *hud;

- (void)globalConfig
{
    self.view.backgroundColor = [GlobalConst appBgColor];

    
//    [hud showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

//- (void)httpRequest
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//
//    [manager POST:[GlobalUtil requestURL:@"user/json/regsms"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dict = (NSDictionary *)responseObject;
//        if ([[dict objectForKey:@"code"] intValue]==1) {
//            
//            
//            
//        }else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//
//}

-(void)showHud {
    
    if (hud == nil) {
        
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        hud = [[MBProgressHUD alloc] initWithWindow:win];
        
        
        [win.rootViewController.view addSubview:hud];
        
        //        [self.view addSubview:hud];
        //        [[UIApplication sharedApplication].keyWindow addSubview:hud];
    }
    
    [hud setLabelText:@"Loading"];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud show:YES];
}

-(void)hideHud {
    
    [hud hide:YES];
    hud = nil;
}


- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success
{
    [hud show:YES];
    
    [self post:url params:params success:^(id responseObj) {
        
        success(responseObj);
        
        [hud hide:YES];
        
    } failure:^(NSError *error) {
        
        [hud hide:YES];
        
        NSLog(@"%@",[params description]);
        NSLog(@"%@",[error description]);
    }];
    
//    [self post:url params:params success:success failure:^(NSError *error) {
//        NSLog(@"%@",[params description]);
//        NSLog(@"%@",[error description]);
//        
//    }];
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [GlobalUtil requestURL:url];
    [HttpTool post:postURL params:params success:success failure:failure];
}

-(NSString*)checkLogin
{
    NSString *uid = [LoginUtil getLocalUUID];
    if (!uid) {
        [[AppDelegate delegate] loginPage];
    }
    
    return uid;
}


/**
 *  隐藏多余分割线
 *
 *  @param tableView <#tableView description#>
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
