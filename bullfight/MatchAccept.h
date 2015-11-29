//
//  MCPay.h
//  bullfight
//
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchFight.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "Team.h"
#import "MatchFight.h"

@interface MatchAccept : UITableViewController<UIAlertViewDelegate>

@property (nonatomic, strong) MatchFight *matchFight;
@property (nonatomic, strong) Team *team;

@end
