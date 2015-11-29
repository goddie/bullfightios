//
//  TIController.h
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "MatchFight.h"
#import "User.h"

@protocol TeamTopDelegate<NSObject>


@required


-(void)changeTab:(NSInteger)idx;

@end



@interface TIController : UITableViewController<TeamTopDelegate>
{
    NSArray *cellArr;
    NSInteger tabIndex;
    NSString *cellIdentifier;
    NSArray *dataArr;
    NSArray *cellHeightArr;
    NSInteger topHeight;
    
    NSMutableArray *dataArr1;
    NSMutableArray *dataArr2;
    NSMutableArray *dataArr3;
    NSMutableArray *dataArr4;
    UIView *sectionHeader;
    NSArray *titleArr;
}

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) Team *team;
@property (nonatomic, strong) MatchFight *matchFight;
@property (nonatomic, strong) User *user;
@end
