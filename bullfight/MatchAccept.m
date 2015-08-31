//
//  MCPay.m
//  bullfight
//  应战
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchAccept.h"
#import "MCPayCell.h"
#import "MCPayTotalCell.h"
#import "MCPayCouponCell.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"
#import <math.h>

@interface MatchAccept ()

@end

@implementation MatchAccept
{
    NSArray *dataArr;
    float arenaPay;
    float judgePay;
    float dataRecordPay;
    float totalPay;
    
    UIButton *btnPayWeiXin;
    UIButton *btnPayAlipay;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];

    [self countFee];
    
    
    self.title = @"支付费用";
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  计算费用
 */
-(void)countFee
{
    
    NSString *mfid = self.matchFight.uuid;
    
    if (!mfid) {
        return;
    }
    
    //计算时间
    NSDictionary *parameters = @{
                                 @"mfid":mfid
                                 };
    
    [self showHud];
    
    [self post:@"payrecord/json/getrecord" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            NSDictionary *pay = [dict objectForKey:@"data"];
            
            arenaPay = [[pay objectForKey:@"arenaFee"] floatValue];
            judgePay = [[pay objectForKey:@"judgeFee"] floatValue];
            dataRecordPay = [[pay objectForKey:@"dataRecordFee"] floatValue];
            
            [self showTable];
            
        }
        
        [self hideHud];
        
    }];
    
    
    
    
    
    
    
}


-(void)showTable
{
    
    NSString *teamSize = [GlobalUtil toString:self.matchFight.teamSize];
    
    NSString *s1  = [NSString stringWithFormat:@"%@vs%@比赛场地费用",teamSize,teamSize];
    
    
    NSString *v1 = [NSString stringWithFormat:@"%d",(int)arenaPay];
    
    
    NSString *s2  = [NSString stringWithFormat:@"%@vs%@比赛裁判费用",teamSize,teamSize];
    NSString *v2 = [NSString stringWithFormat:@"%d",(int)judgePay];
    
    
    NSString *s3  = [NSString stringWithFormat:@"%@vs%@比赛数据员费用",teamSize,teamSize];
    NSString *v3 = [NSString stringWithFormat:@"%d",(int)dataRecordPay];
    
    totalPay = arenaPay + judgePay +dataRecordPay;
    
    NSString *s4  = [NSString stringWithFormat:@"费用总计"];
    NSString *v4 = [NSString stringWithFormat:@"%d",(int)totalPay];
    
    dataArr = @[@[s1,v1],@[s2,v2],@[s3,v3],@[s4,v4]];
    
    [self.tableView reloadData];
    
    //创建比赛，并创建2条待支付记录
//    [self createMatchFight];
}


-(UIView*)getFoot
{
    float w = [UIScreen mainScreen].bounds.size.width;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 200)];
    
    btnPayWeiXin = [[UIButton alloc] initWithFrame:CGRectMake((w-120.0f)*0.5f, 20.0f, 120.0f, 30.0f)];
    [btnPayWeiXin setTitle:@"微信支付" forState:UIControlStateNormal];
    [btnPayWeiXin.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [GlobalUtil set9PathImage:btnPayWeiXin imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [parent addSubview:btnPayWeiXin];
    
    [btnPayWeiXin addTarget:self  action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    
    btnPayAlipay = [[UIButton alloc] initWithFrame:CGRectMake((w-120.0f)*0.5f, btnPayWeiXin.frame.origin.y+btnPayWeiXin.frame.size.height+20, 120.0f, 30.0f)];
    [btnPayAlipay setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [btnPayAlipay.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [GlobalUtil set9PathImage:btnPayAlipay imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [parent addSubview:btnPayAlipay];
    [btnPayAlipay addTarget:self  action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    
    return parent;
}

-(void)btn1Click
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付确认" message:@"您将使用支付宝支付费用" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确认", nil];
    alert.tag = 100;
    [alert show];
}


-(void)btn2Click
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付确认" message:@"您将使用微信支付费用" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确认", nil];
    alert.tag=200;
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    
    if (buttonIndex==0) {
        return;
    }
    
    
    NSString *uid = [LoginUtil getLocalUUID];
    
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"mfid":self.matchFight.uuid,
                                 @"tid":self.team.uuid
                                 };
    
    [self post:@"payrecord/json/payguest" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"支付成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        }
        
        
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArr.count+1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3)
    {
        return 80.0f;
    }
    
    
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==3) {
        static NSString *CellIdentifier = @"MCPayTotalCell";
        MCPayTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.txtTitle.text = [[dataArr objectAtIndex:3] objectAtIndex:0];
        cell.txtPrice.text = [[dataArr objectAtIndex:3] objectAtIndex:1];
        return cell;
    }
    
    if (indexPath.row==4) {
        static NSString *CellIdentifier = @"MCPayCouponCell";
        MCPayCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"MCPayCell";
    MCPayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.txtTitle.text = [[dataArr objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.txtPrice.text = [[dataArr objectAtIndex:indexPath.row] objectAtIndex:1];
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  200.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
   return  [self getFoot];
}



@end
