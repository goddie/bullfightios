//
//  LeagueJoin.h
//  bullfight
//
//  Created by goddie on 16/3/1.
//  Copyright © 2016年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "League.h"

@interface LeagueJoin : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btn1;
- (IBAction)btn1Click:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *img1;

@property (weak, nonatomic) IBOutlet UITextField *txt1;

@property (weak, nonatomic) IBOutlet UITextField *txt2;

@property (weak, nonatomic) IBOutlet UITextField *txt3;

@property (weak, nonatomic) IBOutlet UILabel *txtTeamName;

@property (nonatomic, strong) League *league;

@end
