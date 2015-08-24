//
//  MCJudge.m
//  bullfight
//  裁判和数据员
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MCJudge.h"
#import "MCPay.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"

@interface MCJudge ()

@end

@implementation MCJudge

- (void)viewDidLoad {
    [super viewDidLoad];
    [self globalConfig];
    
    [GlobalUtil set9PathImage:self.btnNext imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    self.title = @"裁判和数据员";
    
    
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

- (IBAction)btnNextClick:(id)sender {
    MCPay *c1 = [[MCPay alloc] initWithNibName:@"MCPay" bundle:nil];
    c1.matchFight = self.matchFight;
    [self.navigationController pushViewController:c1 animated:YES];
}

-(void)clearBtn1
{
    [self.btn11 setBackgroundImage:[UIImage imageNamed:@"shared_selector_inactive.png"] forState:UIControlStateNormal];
    [self.btn12 setBackgroundImage:[UIImage imageNamed:@"shared_selector_inactive.png"] forState:UIControlStateNormal];
    [self.btn13 setBackgroundImage:[UIImage imageNamed:@"shared_selector_inactive.png"] forState:UIControlStateNormal];
}

-(void)clearBtn2
{
    [self.btn21 setBackgroundImage:[UIImage imageNamed:@"shared_selector_inactive.png"] forState:UIControlStateNormal];
    [self.btn22 setBackgroundImage:[UIImage imageNamed:@"shared_selector_inactive.png"] forState:UIControlStateNormal];
    [self.btn23 setBackgroundImage:[UIImage imageNamed:@"shared_selector_inactive.png"] forState:UIControlStateNormal];
}


- (IBAction)btn11Click:(id)sender {
    [self clearBtn1];
    [self.btn11 setBackgroundImage:[UIImage imageNamed:@"shared_selector_active.png"] forState:UIControlStateNormal];
    self.matchFight.judge = [NSNumber numberWithInt:1];
}
- (IBAction)btn12Click:(id)sender {
    [self clearBtn1];
    [self.btn12 setBackgroundImage:[UIImage imageNamed:@"shared_selector_active.png"] forState:UIControlStateNormal];
    self.matchFight.judge = [NSNumber numberWithInt:2];
}
- (IBAction)btn13Click:(id)sender {
    [self clearBtn1];
    [self.btn13 setBackgroundImage:[UIImage imageNamed:@"shared_selector_active.png"] forState:UIControlStateNormal];
    self.matchFight.judge = [NSNumber numberWithInt:3];
}
- (IBAction)btn21Click:(id)sender {
    [self clearBtn2];
    [self.btn21 setBackgroundImage:[UIImage imageNamed:@"shared_selector_active.png"] forState:UIControlStateNormal];
    self.matchFight.dataRecord = [NSNumber numberWithInt:1];
}
- (IBAction)btn22Click:(id)sender {
    [self clearBtn2];
    [self.btn22 setBackgroundImage:[UIImage imageNamed:@"shared_selector_active.png"] forState:UIControlStateNormal];
    self.matchFight.dataRecord = [NSNumber numberWithInt:2];
}
- (IBAction)btn23Click:(id)sender {
    [self clearBtn2];
    [self.btn23 setBackgroundImage:[UIImage imageNamed:@"shared_selector_active.png"] forState:UIControlStateNormal];
    self.matchFight.dataRecord = [NSNumber numberWithInt:3];
}





@end
