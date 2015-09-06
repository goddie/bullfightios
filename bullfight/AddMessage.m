//
//  AddMessage.m
//  bullfight
//
//  Created by goddie on 15/9/3.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "AddMessage.h"
#import "UIViewController+Custome.h"


@interface AddMessage ()

@end

@implementation AddMessage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self globalConfig];
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    //[self.txt1 becomeFirstResponder];
    [self addRightNavButton];
    
    if (self.reply) {
        self.title = [NSString stringWithFormat:@"回复 %@",self.reply.nickname];
    }else
    {
        self.title = @"写评论";
    }
    
    
}

-(void)addRightNavButton
{
    UIButton *commetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];    
    [commetBtn setTitle:@"发布" forState:UIControlStateNormal];
    [commetBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [commetBtn.titleLabel setTextColor:[UIColor redColor]];
//    [commetBtn setTintColor:[UIColor orangeColor]];
    commetBtn.userInteractionEnabled = YES;
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:commetBtn];
    self.navigationItem.rightBarButtonItem = barBtn;
    [commetBtn addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
    
    //    commetBtn.backgroundColor = [UIColor whiteColor];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    
    NSString *uid = [LoginUtil getLocalUUID];
    if (!uid) {
        return;
    }
    
    if (self.mfid.length==0) {
        return;
    }
 
    if (self.txt1.text.length==0) {
        return;
    }
    
    NSString *reply=@"";
    
    if (self.reply) {
        reply = self.reply.uuid;
    }
    
    [self showHud];
 
    NSDictionary *parameters = @{
                                 @"mfid":self.mfid,
                                 @"uid":uid,
                                 @"ruid":reply,
                                 @"content":self.txt1.text
                                 };
    
    [self post:@"commet/json/add" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            
            
            [self.navigationController popViewControllerAnimated:YES];
 
        }
        
        [self hideHud];
    }];
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入内容"])
    {
        textView.text = @"";
//        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

-(void)rightPush
{
    [self loadData];
}

- (IBAction)btn1Click:(id)sender {
    
    [self loadData];
}
@end
