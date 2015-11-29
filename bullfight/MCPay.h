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

@interface MCPay : UITableViewController<UIAlertViewDelegate>

@property (nonatomic, strong) MatchFight *matchFight;

@end
