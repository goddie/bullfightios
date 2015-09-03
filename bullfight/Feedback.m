//
//  Feedback.m
//  bullfight
//
//  Created by goddie on 15/9/1.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "Feedback.h"
#import "UIViewController+Custome.h"

@interface Feedback ()

@end

@implementation Feedback

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    self.title = @"意见反馈";
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
    
    
    if([self.txt1.text length]==0)
    {
        return;
    }

    
    NSString *uid = [LoginUtil getLocalUUID];

    NSDictionary *parameters = @{
                                 @"content":self.txt1.text,
                                 @"uid":uid
                                 };
    
    
    [self post:@"feedback/json/add" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交成功" message:@"感谢您提出宝贵意见，我们的工作人员将尽快与您取得联系。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    }];
}
@end
