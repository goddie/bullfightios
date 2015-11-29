//
//  RegOne.m
//  touzimao
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "RegTwo.h"
#import "RegThree.h"
#import "UIViewController+Custome.h"

@interface RegTwo ()

@end

@implementation RegTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    self.view.backgroundColor = [GlobalConst appBgColor];
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [GlobalUtil set9PathImage:self.btn2 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"请输入登录帐号" attributes:@{ NSForegroundColorAttributeName : [GlobalConst lightAppBgColor] }];
    self.txt1.attributedPlaceholder = str;
    
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{ NSForegroundColorAttributeName : [GlobalConst lightAppBgColor] }];
    self.txt2.attributedPlaceholder = str2;
    
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"请输入昵称" attributes:@{ NSForegroundColorAttributeName : [GlobalConst lightAppBgColor] }];
    self.txt3.attributedPlaceholder = str3;
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入帐号" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if([self.txt2.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if([self.txt3.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入用户名" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    
    NSString *uid = [LoginUtil getLocalUUID];
    if(uid.length==0)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"username":self.txt1.text,
                                 @"password":self.txt2.text,
                                 @"nickname":self.txt3.text,
                                 @"uid":uid
                                 };

    
    [self post:@"user/json/regtwo" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
            
            NSDictionary *data = [dict objectForKey:@"data"];
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];
            [LoginUtil saveLocalUser:model];
            [LoginUtil saveLocalUUID:model];
            
            RegThree *c1 = [[RegThree alloc] initWithNibName:@"RegThree" bundle:nil];
            [self.navigationController pushViewController:c1 animated:YES];

        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        

        
    }];
    
    

}
@end
