//
//  RegTwo.h
//  bullfight
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface RegThree : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
- (IBAction)btn1Click:(id)sender;
- (IBAction)btn2Click:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *img1;

@property (nonatomic, strong) User *user;

@end
