//
//  TIController.h
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TIController : UITableViewController

-(void)reminder;

-(void)switchView:(id)sender;

@property (nonatomic, strong) NSString *uuid;

@end
