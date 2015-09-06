//
//  MatchFutureTop.m
//  bullfight
//
//  Created by goddie on 15/8/8.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MFWildTop.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "MCPay.h"
#import "AppDelegate.h"
#import "MatchAcceptTeam.h"
#import "TabBarBlue.h"
#import "MyButton.h"

@interface MFWildTop ()

@end

@implementation MFWildTop
{
    BOOL isLeader;
    TabBarBlue *seg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GlobalConst appBgColor];
    // Do any additional setup after loading the view from its nib.
    
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(55.0f, 55.0f)];
    [GlobalUtil setMaskImageQuick:self.img2 withMask:@"round_mask.png" point:CGPointMake(55.0f, 55.0f)];
    
    
//    [GlobalUtil addButtonToView:self sender:self.img2  action:@selector(openTeam1) data:nil];
//    [self.seg addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    
    seg = [[TabBarBlue alloc] initWithFrame:CGRectMake(0, 0, 0,0)];
    [seg setTitles:@[@"比赛信息",@"球队数据",@"个人数据",@"赛前动员"]];
    [seg addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    [self.topHolder addSubview:seg];
    
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    isLeader = NO;
    
    
    [self bindData];
    [self checkUser];
}

-(void)openTeam1:(MyButton*)sender
{
    
    TIController *c1 = [[TIController alloc] initWithNibName:@"TIController" bundle:nil];
    NSDictionary* dict =(NSDictionary*)sender.data;
    Team *t = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:dict error:nil];
    c1.team = t;
    c1.uuid = t.uuid;
    [self.navigationController pushViewController:c1 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchView:(id)sender{
    [self.topDelegate changeTab:seg.selectedSegmentIndex];
}


-(void)bindData
{

    if([self.matchFight.host objectForKey:@"avatar"])
    {
        NSString *a1 = [@"" stringByAppendingString:[self.matchFight.host objectForKey:@"avatar"]];
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a1]];
        [self.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
    

    
    [GlobalUtil addButtonToView:self sender:self.img1  action:@selector(openTeam1:) data:self.matchFight.host];
 
    
    self.txtTeam1.text = [self.matchFight.host objectForKey:@"name"];
    //self.txtTeam2.text = [self.matchFight.guest objectForKey:@"name"];
    
    self.txtNo1.text = [GlobalUtil toString:self.matchFight.teamSize];
    self.txtNo2.text = [GlobalUtil toString:self.matchFight.teamSize];
    
    
    NSString *uuid = [LoginUtil getLocalUUID];
    
    
    NSDictionary *dict = [self.matchFight.host objectForKey:@"admin"];
    
    NSString *hostAdmin = [GlobalUtil toString:[dict objectForKey:@"id"]];
    
    if ([uuid isEqualToString:hostAdmin]) {
        self.btn1.hidden=YES;
    }
    
}


- (IBAction)btn1Click:(id)sender {
    
    NSString *uuid = [LoginUtil getLocalUUID];
    
    if (!uuid) {
        [[AppDelegate delegate] loginPage];
        return;
    }
 
    
    if (self.matchFight.uuid.length==0) {
        return;
    }
    
    
    if (isLeader) {
        
//        NSDictionary *parameters = @{
//                                     @"uid":uuid,
//                                     @"mfid":self.matchFight.uuid
//                                     };
        
        MatchAcceptTeam *c1 = [[MatchAcceptTeam alloc] initWithNibName:@"MatchAcceptTeam" bundle:nil];
        c1.matchFight = self.matchFight;
        [self.navigationController pushViewController:c1 animated:YES];
        
//        [self post:@"matchfight/json/accept" params:parameters success:^(id responseObj) {
//            
//            NSDictionary *dict = (NSDictionary *)responseObj;
//            
//            NSString *msg = [NSString stringWithFormat:@"%@",[dict objectForKey:@"msg"]];
//            
//            if ([[dict objectForKey:@"code"] intValue]==1) {
//                
//                
//                
//            }
//            
//            if (msg.length>0) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                
//                [alert show];
//            }
//            
//        }];
    }else
    {
        
        NSDictionary *parameters = @{
                                     @"uid":uuid,
                                     @"mfid":self.matchFight.uuid
                                     };
        
        [self post:@"message/json/sendtoteam" params:parameters success:^(id responseObj) {
            
            NSDictionary *dict = (NSDictionary *)responseObj;
            
            NSString *msg = [NSString stringWithFormat:@"%@",[dict objectForKey:@"msg"]];
            
            if ([[dict objectForKey:@"code"] intValue]==1) {
                

                
            }
            
            if (msg.length>0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alert show];
            }

            
        }];
    }
    
    
}


-(void)setButton
{

    
    if (isLeader) {
        [self.btn1 setTitle:@"应战" forState:UIControlStateNormal];
    }else
    {
        [self.btn1 setTitle:@"通知队长" forState:UIControlStateNormal];
    }
}

-(void)checkUser
{
    
    NSString *uuid = [LoginUtil getLocalUUID];
    
    if (uuid.length==0) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uuid
                                 };
    
    __weak MFWildTop * wself = self;
    [self post:@"team/json/checkuser" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            isLeader = YES;
            
        }
        
        [wself setButton];
        
    }];
    

    
}

@end
