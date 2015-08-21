//
//  ManaTITop.m
//  bullfight
//
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//
#import "ManaTIJoinTop.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"

@interface ManaTIJoinTop ()

@end

@implementation ManaTIJoinTop

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    [GlobalUtil setMaskImageQuick:self.img withMask:@"round_mask.png" point:CGPointMake(80.0f, 80.0f)];
    
    //    [GlobalUtil addButtonToView:self sender:self.btn1  action:@selector(reminder) data:nil];
    
    [self.seg addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    
    [self bindData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn1Click:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出球队" message:@"确定退出球队吗" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *uid = [LoginUtil getLocalUUID];
    
    if (buttonIndex==0) {
        return;
    }
    
    if(!uid)
    {
        return;
    }
    
    if(!self.team)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"tid":self.team.uuid,
                                 @"uid":uid
                                 };
    
     __weak ManaTIJoinTop * wself = self;
    [self post:@"teamuser/json/quit" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        [wself.navigationController popViewControllerAnimated:YES];
        
    }];

}



-(void)switchView:(id)sender{
    [self.topDelegate changeTab:self.seg.selectedSegmentIndex];
}

-(void)bindData
{
    if (!self.team) {
        return;
    }
    
    NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.team.avatar]];
    [self.img sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    
    
    self.txtFound.text = [GlobalUtil getDateFromUNIX:self.team.createdDate];
    self.txtName.text = self.team.name;
    self.txtInfo.text = self.team.info;
}

@end
