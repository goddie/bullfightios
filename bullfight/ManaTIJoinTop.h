//
//  ManaTITop.h
//  bullfight
//
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIController.h"
#import "Team.h"

@interface ManaTIJoinTop : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtFound;
@property (weak, nonatomic) IBOutlet UILabel *txtInfo;

@property (weak, nonatomic) IBOutlet UIButton *btn1;

- (IBAction)btn1Click:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *topHolder;
 

@property (nonatomic, strong) id<TeamTopDelegate> topDelegate;

@property (nonatomic, strong) Team *team;

@end
