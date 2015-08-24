//
//  AppDelegate.h
//  bullfight
//
//  Created by goddie on 15/8/4.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)changeRoot;

-(void)loginPage;

+ (AppDelegate *)delegate;

@end

