//
//  MCTeam.m
//  bullfight
//  球队和比赛形式
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MCTeam.h"
#import "MCPlace.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"
#import "MCTeamList.h"
#import "TeamCreate.h"

@interface MCTeam ()

@end

@implementation MCTeam


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(selectTeam:) name:@"selectTeam" object:nil];
    
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(100.0f, 100.0f)];
    [GlobalUtil set9PathImage:self.btnNext imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    self.title = @"球队和比赛形式";
    
    [self globalConfig];
    
    [GlobalUtil addButtonToView:self sender:self.img1 action:@selector(chooseTeam) data:nil];
    
 
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 


-(void)selectTeam:(NSNotification*)notice
{
    self.team = (Team*)notice.object;
    self.matchFight.host = @{@"hostid": self.team.uuid};
    [self bindTeam];
}


- (IBAction)btnNextClick:(id)sender {
    
    if (self.matchFight.teamSize<=0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择比赛人数" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        return;
    }
    
    MCPlace *c1 = [[MCPlace alloc] initWithNibName:@"MCPlace" bundle:nil];
    c1.matchFight = self.matchFight;
    [self.navigationController pushViewController:c1 animated:YES];
    
}



-(void)chooseTeam
{
    MCTeamList *c1 = [[MCTeamList alloc] initWithNibName:@"MCTeamList" bundle:nil];
    
//    self.navigationController.delegate = c1;
    
    [self.navigationController pushViewController:c1 animated:YES];
    
}


-(void)clearButtonBg
{

    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"shared_picker_unselected@3x.png"] forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"shared_picker_unselected@3x.png"] forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"shared_picker_unselected@3x.png"] forState:UIControlStateNormal];
    [self.btn4 setBackgroundImage:[UIImage imageNamed:@"shared_picker_unselected@3x.png"] forState:UIControlStateNormal];
    
}


-(void)bindTeam
{
    if (!self.team) {
        return;
    }
    
    self.matchFight.host = @{@"hostid": self.team.uuid};
    
    if(self.team.avatar)
    {
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.team.avatar]];
        [self.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 200) {
        
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        if (buttonIndex==1) {
            
            TeamCreate *c1 = [[TeamCreate alloc] initWithNibName:@"TeamCreate" bundle:nil];
            [self.navigationController pushViewController:c1 animated:YES];
            
        }
        
    }
}


-(void)getData
{
    NSString *uuid = [LoginUtil getLocalUUID];
    if (!uuid.length) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uuid
                                 };
    
    __weak MCTeam * wself = self;
    
    [self post:@"teamuser/json/mymanateam" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
            NSError *error = nil;
            
            
            if (arr.count) {
                
                NSDictionary *data = [arr firstObject];
                
                Team *model = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:data error:&error];
                
                if (model!=nil) {
                    
                    self.team = model;
                    [wself bindTeam];
                    
                }

            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有球队" message:@"您没有自己的球队，是否创建球队?" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"创建球队", nil];
                alert.tag = 200;
                [alert show];
            }
            
 
        } 
    }];
    
}



- (IBAction)sizeClick:(id)sender {
    
    [self clearButtonBg];
    
    UIButton *btn = (UIButton*)sender;
    [btn setBackgroundImage:[UIImage imageNamed:@"shared_picker_selected@3x.png"] forState:UIControlStateNormal];
    self.matchFight.teamSize = [NSNumber numberWithInteger:btn.tag];
    
}


@end
