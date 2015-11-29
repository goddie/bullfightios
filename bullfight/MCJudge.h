//
//  MCJudge.h
//  bullfight
//
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchFight.h"

@interface MCJudge : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)btnNextClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn11;
- (IBAction)btn11Click:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn12;
- (IBAction)btn12Click:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *btn13;
- (IBAction)btn13Click:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *btn21;
- (IBAction)btn21Click:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn22;
- (IBAction)btn22Click:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn23;

- (IBAction)btn23Click:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnFree;
- (IBAction)btnFreeClick:(id)sender;







@property (nonatomic, strong) MatchFight *matchFight;
@end
