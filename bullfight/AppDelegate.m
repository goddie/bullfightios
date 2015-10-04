//
//  AppDelegate.m
//  bullfight
//
//  Created by goddie on 15/8/4.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "LoginUtil.h"
#import "RegOne.h"
#import "IQKeyboardManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "HttpUtil.h"

 

static AppDelegate *appDelegate = nil;

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    MainController *mainController;
 
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    appDelegate = self;
    
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    
    
    //1.创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [GlobalConst appBgColor];
    
    //a.初始化一个tabBar控制器
    mainController=[[MainController alloc] initWithNibName:@"MainController" bundle:nil];
    
    
//    if ([LoginUtil getLocalUUID]==NULL) {
//        
//        RegOne *c1  = [[RegOne alloc] initWithNibName:@"RegOne" bundle:nil];
//        
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c1];
//        
//        //设置控制器为Window的根控制器
//        self.window.rootViewController=nav;
//    }else
//    {
//        //设置控制器为Window的根控制器
//        self.window.rootViewController=mainController;
//    }
    
    
    self.window.rootViewController=mainController;
    
    //2.设置Window为主窗口并显示出来
    [self.window makeKeyAndVisible];
    
    
//    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
//    NSArray *fontNames;
//    NSInteger indFamily, indFont;
//
//    for(indFamily=0;indFamily<[familyNames count];++indFamily)
//        
//    {
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
//        
//        for(indFont=0; indFont<[fontNames count]; ++indFont)
//            
//        {
//            NSLog(@"Font name: %@",[fontNames objectAtIndex:indFont]);
//            
//        }
//        
//    }
    
    [WXApi registerApp:@"wxd930ea5d5a258f4f"];
    
    [self messageTimer];
    
//    [CheckUtil check];
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //NSLog(@"result = %@",resultDic);
                                                      
                                                      //                                                      if ([[resultDic objectForKey:@"resultStatus"] intValue]==9000) {
                                                      //                                                          [self paySuccess:[resultDic objectForKey:@"result"]];
                                                      //                                                      }
                                                      
                                                      
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了, 所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就 是在这个方法里面处理跟 callback 一样的逻辑】
            //NSLog(@"result = %@",resultDic);
            //
            //            if ([[resultDic objectForKey:@"resultStatus"] intValue]==9000) {
            //                [self paySuccess:[resultDic objectForKey:@"result"]];
            //            }
            
        }];
    }
    
    
    return YES;
}


/**
 *  新消息倒计时刷新
 */
-(void)messageTimer
{
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(messagePull) userInfo:nil repeats:YES];
}


-(void)messagePull{
//    NSLog(@"messagePull");
    //未读消息
    NSString *uid = [LoginUtil getLocalUUID];
    if(!uid)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uid
                                 };
    
    [HttpTool post:[baseURL stringByAppendingString:@"message/json/countnew"] params:parameters success:^(id json) {
        NSDictionary *dict = (NSDictionary *)json;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSNumber *count = (NSNumber*)[dict objectForKey:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"countnew" object:count];
        }
    } failure:^(NSError *error) {
        
    }];
 
}


-(void)changeRoot
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
//    [self.window addSubview:mainController.view];
//    
//    [self.window.rootViewController.view removeFromSuperview];
//    
//    self.window.rootViewController = mainController;
}


+ (AppDelegate *)delegate{
    
    return appDelegate;
    
}

-(void)loginPage
{
    NSString *uuid = [LoginUtil getLocalUUID];
    
    [self changeTab:0];
    
    if (!uuid) {
        
        RegOne *c1 = [[RegOne alloc] initWithNibName:@"RegOne" bundle:nil];
        
        UINavigationController *nav  = [[UINavigationController alloc] initWithRootViewController:c1];
        
        [appDelegate.window.rootViewController presentViewController:nav animated:YES completion:^{
            
        }];
        
    }

}

-(void)changeTab:(NSInteger)idx
{
    mainController.selectedIndex = idx;
}

@end
