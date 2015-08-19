//
//  MatchCreate.h
//  bullfight
//
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchCreate : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnFree;
- (IBAction)btnFreeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnTeam;
- (IBAction)btnTeamClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnClose;
- (IBAction)btnCloseClick:(id)sender;
@end
