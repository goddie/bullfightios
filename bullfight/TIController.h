//
//  TIController.h
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"


@protocol TeamTopDelegate<NSObject>

@required


-(void)changeTab:(NSInteger)idx;

@end



@interface TIController : UITableViewController<TeamTopDelegate>

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) Team *team;


@end
