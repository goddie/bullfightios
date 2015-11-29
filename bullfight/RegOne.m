//
//  RegOne.m
//  touzimao
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "RegOne.h"
#import "RegTwo.h"
#import "Login.h"
#import "UIViewController+Custome.h"
#import "AppDelegate.h"

@interface RegOne ()

@end

@implementation RegOne

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    self.view.backgroundColor = [GlobalConst appBgColor];
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [GlobalUtil set9PathImage:self.btn2 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{ NSForegroundColorAttributeName : [GlobalConst lightAppBgColor] }];
    self.txt1.attributedPlaceholder = str;
    
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"请输入收到的验证码" attributes:@{ NSForegroundColorAttributeName : [GlobalConst lightAppBgColor] }];
    self.txt2.attributedPlaceholder = str2;
    
    [self addLeftNavButton];
    
}



-(void)addLeftNavButton
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(0,0,26,30)];
    
//    [refreshButton setTitle:@"" forState:UIControlStateNormal];
//    [refreshButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    refreshButton.userInteractionEnabled = YES;
    [refreshButton setImage:[UIImage imageNamed:@"nav_btn_cancel.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    self.navigationItem.leftBarButtonItem = refreshBarButton;
    [refreshButton addTarget:self action:@selector(leftPush) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)leftPush
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
    
    if([self.txt1.text length]==0)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"phone":self.txt1.text
                                 };
    
    
    [self post:@"user/json/regsms" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
//            RegTwo *c1 = [[RegTwo alloc] initWithNibName:@"RegTwo" bundle:nil];
//            [self.navigationController pushViewController:c1 animated:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已发送验证码到手机短信，请注意查看。" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
//
//            NSDictionary *data = [dict objectForKey:@"data"];
//            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];
//            
//            [LoginUtil saveLocalUser:model];
//            
//            [LoginUtil saveLocalUUID:model];
            
            //            RegTwo *c1 = [[RegTwo alloc] initWithNibName:@"RegTwo" bundle:nil];
            //            [self.navigationController pushViewController:c1 animated:YES];
        }else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该手机号已注册" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        

        
    }];

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
                                 @"phone":self.txt1.text,
                                 @"code":self.txt2.text
                                 };

    
    [self post:@"user/json/regcheck" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
            
            NSDictionary *data = [dict objectForKey:@"data"];
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];

            [LoginUtil saveLocalUser:model];

            [LoginUtil saveLocalUUID:model];

            RegTwo *c1 = [[RegTwo alloc] initWithNibName:@"RegTwo" bundle:nil];
            [self.navigationController pushViewController:c1 animated:YES];
        }else
        {
//            if([[dict objectForKey:@"msg"] count]==0)
//            {
//                return ;
//            }
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
        }
        
//        RegTwo *c1 = [[RegTwo alloc] initWithNibName:@"RegTwo" bundle:nil];
//        [self.navigationController pushViewController:c1 animated:YES];
        
    }];
    
    

}
- (IBAction)btn3Click:(id)sender {
    Login *c1 = [[Login alloc] initWithNibName:@"Login" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
    
}
@end
