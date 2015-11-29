//
//  MatchTeam.h
//  bullfight
//
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchTeam : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *btnParent;
@property (weak, nonatomic) IBOutlet UIView *topView;
 




@end
