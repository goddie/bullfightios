//
//  RegOne.m
//  touzimao
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "UserPassword.h"
#import "RegThree.h"
#import "UIViewController+Custome.h"

@interface UserPassword ()

@end

@implementation UserPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    self.view.backgroundColor = [GlobalConst appBgColor];
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [GlobalUtil set9PathImage:self.btn2 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{ NSForegroundColorAttributeName : [GlobalConst lightAppBgColor] }];
    self.txt1.attributedPlaceholder = str;
    
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"请确认密码" attributes:@{ NSForegroundColorAttributeName : [GlobalConst lightAppBgColor] }];
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
    
    if (![self.txt1.text isEqualToString:self.txt2.text]) {
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"错误" message:@"两次密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
    
    
    NSString *uid = [LoginUtil getLocalUUID];
    if(uid.length==0)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"password":self.txt1.text,
                                 @"uid":uid
                                 };

    
    [self post:@"user/json/uppassword" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
         
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];

        }

        
    }];
    
    

}
@end
