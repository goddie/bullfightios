//
//  MCTeam.h
//  bullfight
//
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCTeam : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UILabel *txt1;
@property (weak, nonatomic) IBOutlet UILabel *txt2;
@property (weak, nonatomic) IBOutlet UILabel *txt3;
@property (weak, nonatomic) IBOutlet UILabel *txt4;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
- (IBAction)btnNextClick:(id)sender;

@end
