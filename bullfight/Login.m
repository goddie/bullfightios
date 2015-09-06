//
//  RegOne.m
//  touzimao
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "Login.h"
#import "RegThree.h"
#import "UIViewController+Custome.h"
#import "AppDelegate.h"
#import "FindPwd.h"

@interface Login ()

@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    self.view.backgroundColor = [GlobalConst appBgColor];
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [GlobalUtil set9PathImage:self.btn2 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"请输入用户名/手机号" attributes:@{ NSForegroundColorAttributeName : [GlobalConst lightAppBgColor] }];
    self.txt1.attributedPlaceholder = str;
    
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{ NSForegroundColorAttributeName : [GlobalConst lightAppBgColor] }];
    self.txt2.attributedPlaceholder = str2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn1Click:(id)sender {
}
- (IBAction)btn2Click:(id)sender {
    
    if([self.txt1.text length]==0)
    {
        return;
    }
    
    if([self.txt2.text length]==0)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"username":self.txt1.text,
                                 @"password":self.txt2.text,
                                 };

    
    [self post:@"user/json/login" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
            
            NSDictionary *data = [dict objectForKey:@"data"];
            NSError *error;
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
            //NSLog(@"%@",[error description]);
            [LoginUtil saveLocalUser:model];
            [LoginUtil saveLocalUUID:model];
            //[LoginUtil saveUserJSON:responseObj];
            
            [[AppDelegate delegate] changeRoot];

        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        

        
    }];
    
    

}
- (IBAction)btn3Click:(id)sender {
    
    FindPwd *c1 = [[FindPwd alloc] initWithNibName:@"FindPwd" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
    
}
@end
