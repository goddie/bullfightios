//
//  RegOne.h
//  touzimao
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Login : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;
- (IBAction)btn1Click:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
- (IBAction)btn2Click:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt2;

@end
