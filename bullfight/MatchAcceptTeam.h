//
//  MyTeamController.h
//  bullfight
//
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "MatchFight.h"

@interface MatchAcceptTeam : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
 
@property (weak, nonatomic) IBOutlet UICollectionView *tableView;


@property (nonatomic, strong) MatchFight *matchFight;
@property (nonatomic, strong) Team *team;


@end
