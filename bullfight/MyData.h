//
//  MyData.h
//  bullfight
//
//  Created by goddie on 15/8/19.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyData : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end
