//
//  My.h
//  bullfight
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface My : UIViewController

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
- (IBAction)btn1Click:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn2;
- (IBAction)btn2Click:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *txt1;

@property (weak, nonatomic) IBOutlet UILabel *txt2;

@property (weak, nonatomic) IBOutlet UILabel *txt3;
@property (weak, nonatomic) IBOutlet UILabel *txtCity;

@property (nonatomic, strong) NSString *userId;

@end
