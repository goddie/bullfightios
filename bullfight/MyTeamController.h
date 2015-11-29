//
//  MyTeamController.h
//  bullfight
//
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTeamController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *tableView;

@end
