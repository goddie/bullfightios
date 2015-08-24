//
//  MCPlace.h
//  bullfight
//
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchFight.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"

@interface MCPlace : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
- (IBAction)btnNextClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *txtArena;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txtStart;
@property (weak, nonatomic) IBOutlet UITextField *txtEnd;


@property (nonatomic, strong) MatchFight *matchFight;
@property (nonatomic, strong) NSString *arenaid;
@property (nonatomic, strong) NSString *arenaName;
@end
