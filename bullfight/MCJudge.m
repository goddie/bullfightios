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
    [GlobalUtil set9PathImage:self.btnFree imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
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
    
    if (self.matchFight.judge<=0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择裁判人数" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        return;
    }
    
    if (self.matchFight.dataRecord<=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择数据员人数" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        return;
    }
    
    
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





- (IBAction)btnFreeClick:(id)sender {
    
    [self clearBtn1];
    [self clearBtn2];
    
    self.matchFight.judge = [NSNumber numberWithInt:0];
    self.matchFight.dataRecord = [NSNumber numberWithInt:0];
    
    MCPay *c1 = [[MCPay alloc] initWithNibName:@"MCPay" bundle:nil];
    c1.matchFight = self.matchFight;
    [self.navigationController pushViewController:c1 animated:YES];
    
//    NSString *uuid = [LoginUtil getLocalUUID];
//    if (uuid.length==0) {
//        return;
//    }
//    
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[self.matchFight.start doubleValue]];
//    
//    NSString *start =  [formatter stringFromDate:startDate];
//    
//    
//    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[self.matchFight.end doubleValue]];
//    NSString *end = [formatter stringFromDate:endDate];
//    
//    
//    
//    
//    
//    
//    //    NSLog(@"%@",[self.matchFight description]);
//    
//    NSString *tid = [GlobalUtil toString:[self.matchFight.host objectForKey:@"hostid"]];
//    NSString *aid = [GlobalUtil toString:[self.matchFight.arena objectForKey:@"aid"]];
//    NSString *type = [GlobalUtil toString:self.matchFight.matchType];
//    NSString *size = [GlobalUtil toString:self.matchFight.teamSize];
//    NSString *judge = [GlobalUtil toString:self.matchFight.judge];
//    NSString *data  = [GlobalUtil toString:self.matchFight.dataRecord];
//    NSString *content  = [GlobalUtil toString:self.matchFight.content];
//    
//    NSDictionary *parameters = @{
//                                 @"uid":uuid,
//                                 @"tid":tid,
//                                 @"aid":aid,
//                                 @"matchType":type,
//                                 @"status":@"0",
//                                 @"startStr":start,
//                                 @"endStr":end,
//                                 @"guestScore":@"0",
//                                 @"hostScore":@"0",
//                                 @"teamSize":size,
//                                 @"judge":@"0",
//                                 @"dataRecord":@"0",
//                                 @"isPay":@"0",
//                                 @"fee":@"0",
//                                 @"content":content
//                                 };
//    
//    //    MCPay *c1 = [[MCPay alloc] initWithNibName:@"MCPay" bundle:nil];
//    //    [self.navigationController pushViewController:c1 animated:YES];
//    
//    [self showHud];
//    
//    [self post:@"matchfight/json/add" params:parameters success:^(id responseObj) {
//        
//        NSDictionary *dict = (NSDictionary *)responseObj;
//        
//        
//        
//        if ([[dict objectForKey:@"code"] intValue]==1) {
//            
//            
//            NSDictionary *data = [dict objectForKey:@"data"];
//            MatchFight *model = [MTLJSONAdapter modelOfClass:[MatchFight class] fromJSONDictionary:data error:nil];
//            if (model) {
//                self.matchFight = model;
//            }
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"创建比赛成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            
//            [alert show];
//            [self.navigationController popToRootViewControllerAnimated:NO];
//            
//        }
//        
//        //        if ([dict objectForKey:@"msg"]) {
//        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[dict objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        //
//        //            [alert show];
//        //        }
//        [self hideHud];
//    }];


}
@end
