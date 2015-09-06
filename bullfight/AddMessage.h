//
//  AddMessage.h
//  bullfight
//
//  Created by goddie on 15/9/3.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface AddMessage : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn1;

- (IBAction)btn1Click:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *txt1;

@property (nonatomic, strong) NSString *mfid;
@property (nonatomic, strong) User *reply;
@end
