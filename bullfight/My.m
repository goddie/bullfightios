//
//  My.m
//  bullfight
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "My.h"
#import "UIViewController+Custome.h"
#import "MyData.h"
#import "UIImageView+WebCache.h"
#import "MyTeamController.h"
#import "UserInfo.h"
#import "RegOne.h"
#import "AppDelegate.h"


@interface My ()

@end

@implementation My
{
    User *entity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [GlobalUtil set9PathImage:self.btn2 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    
    [GlobalUtil addButtonToView:self sender:self.view1 action:@selector(view1Click) data:nil];
    [GlobalUtil addButtonToView:self sender:self.view2 action:@selector(view2Click) data:nil];
    [GlobalUtil addButtonToView:self sender:self.view3 action:@selector(view3Click) data:nil];
    
    
    
    self.title = @"我";
    
    [self addRightNavButton];
}


-(void)addRightNavButton
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(0,0,26,30)];
    
    [refreshButton setTitle:@"退出" forState:UIControlStateNormal];
    [refreshButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    refreshButton.userInteractionEnabled = YES;
    //[refreshButton setImage:[UIImage imageNamed:@"nav_filter.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    [refreshButton addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];


}



-(void)rightPush
{
    [LoginUtil clearLocal];
    
    [[AppDelegate delegate] loginPage];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *uuid = [LoginUtil getLocalUUID];
    
    if (!uuid) {
        
        RegOne *c1 = [[RegOne alloc] initWithNibName:@"RegOne" bundle:nil];
        
        UINavigationController *nav  = [[UINavigationController alloc] initWithRootViewController:c1];
        
        [self presentViewController:nav animated:YES completion:^{
            
        }];
        
        
        
    }
    
    
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData
{
//    NSString *uid = [LoginUtil getLocalUUID];
    if (self.userId.length==0) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":self.userId
                                 };
    
    
    [self post:@"user/json/getuser" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [dict objectForKey:@"data"];
            NSError *error = nil;
            entity = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
            
            //NSLog(@"%@",[error description]);
            
//            if (model!=nil) {
//                
//                entity = [model copy];
//            }
            [self bindData];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        
        
    }];
}


-(void)bindData
{
    self.txt1.text = [GlobalUtil toString:entity.follows];
    self.txt2.text = [GlobalUtil toString:entity.fans];
    self.txt3.text = @"99";
    
    self.txtCity.text = [GlobalUtil toString:entity.city];
    
}

-(void)view1Click
{
    MyData *myData = [[MyData alloc] initWithNibName:@"MyData" bundle:nil];
    [self.navigationController pushViewController:myData animated:YES];
}

-(void)view2Click
{
    MyTeamController *c1 = [[MyTeamController alloc] initWithNibName:@"MyTeamController" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
}

-(void)view3Click
{
    
}

- (IBAction)btn1Click:(id)sender {
    UserInfo *c1 = [[UserInfo alloc] initWithNibName:@"UserInfo" bundle:nil];
    c1.user = entity;
    [self.navigationController pushViewController:c1 animated:YES];
}

- (IBAction)btn2Click:(id)sender {
    
}
@end
