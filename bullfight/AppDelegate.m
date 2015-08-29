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
