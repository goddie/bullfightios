//
//  MCPay.m
//  bullfight
//  支付场地费
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MCPay.h"
#import "MCPayCell.h"
#import "MCPayTotalCell.h"
#import "MCPayCouponCell.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"
#import <math.h>

@interface MCPay ()

@end

@implementation MCPay
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
    
    NSString *aid = [self.matchFight.arena objectForKey:@"aid"];
    
    
    //计算时间
    NSDictionary *parameters = @{
                                 @"aid":aid
                                 };
    
    //    MCPay *c1 = [[MCPay alloc] initWithNibName:@"MCPay" bundle:nil];
    //    [self.navigationController pushViewController:c1 animated:YES];
    
    [self post:@"arena/json/getPrice" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            NSArray *arr = [dict objectForKey:@"data"];
            
            arenaPay = [[arr objectAtIndex:0] floatValue];
            judgePay = [[arr objectAtIndex:1] floatValue];
            dataRecordPay = [[arr objectAtIndex:2] floatValue];
            
            [self showTable];
            
        }
        
        
        NSString *msg = [GlobalUtil toString:[dict objectForKey:@"msg"]];
        
        if (msg.length>0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[dict objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
    }];
    
    
    
    
    
    
    
}


-(void)showTable
{
    
    NSString *teamSize = [GlobalUtil toString:self.matchFight.teamSize];
    
    NSString *s1  = [NSString stringWithFormat:@"%@vs%@比赛场地费用",teamSize,teamSize];
    
    double t1 =  [self.matchFight.start doubleValue];
    double t2 =  [self.matchFight.end doubleValue];
    
    double count = ceilf(( t2 - t1 ) / (60.0f*60.0f));
    
    int t = (count * arenaPay)*0.5f;
    NSString *v1 = [NSString stringWithFormat:@"%d",t];
    
    
    int j = judgePay * [self.matchFight.judge intValue] *0.5f;
    
    NSString *s2  = [NSString stringWithFormat:@"%@vs%@比赛裁判费用",teamSize,teamSize];
    NSString *v2 = [NSString stringWithFormat:@"%d",j];
    
    int d = dataRecordPay * [self.matchFight.dataRecord intValue] *0.5f;
    
    NSString *s3  = [NSString stringWithFormat:@"%@vs%@比赛数据员费用",teamSize,teamSize];
    NSString *v3 = [NSString stringWithFormat:@"%d",d];
    
    totalPay = t+j+d;
    
    NSString *s4  = [NSString stringWithFormat:@"费用总计"];
    NSString *v4 = [NSString stringWithFormat:@"%d",(int)(totalPay)];
    
    dataArr = @[@[s1,v1],@[s2,v2],@[s3,v3],@[s4,v4]];
    
    [self.tableView reloadData];
    
    //创建比赛，并创建2条待支付记录
    [self createMatchFight];
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


-(void)createMatchFight
{
    
    NSString *uuid = [LoginUtil getLocalUUID];
    if (uuid.length==0) {
        return;
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[self.matchFight.start doubleValue]];
    
    NSString *start =  [formatter stringFromDate:startDate];
    
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[self.matchFight.end doubleValue]];
    NSString *end = [formatter stringFromDate:endDate];
    
    
    
    
    
    
    //    NSLog(@"%@",[self.matchFight description]);
    
    NSString *tid = [GlobalUtil toString:[self.matchFight.host objectForKey:@"hostid"]];
    NSString *aid = [GlobalUtil toString:[self.matchFight.arena objectForKey:@"aid"]];
    NSString *type = [GlobalUtil toString:self.matchFight.matchType];
    NSString *size = [GlobalUtil toString:self.matchFight.teamSize];
    NSString *judge = [GlobalUtil toString:self.matchFight.judge];
    NSString *data  = [GlobalUtil toString:self.matchFight.dataRecord];
    NSString *total = [NSString stringWithFormat:@"%d",(int)(totalPay)];
    
    NSDictionary *parameters = @{
                                 @"uid":uuid,
                                 @"tid":tid,
                                 @"aid":aid,
                                 @"matchType":type,
                                 @"status":@"0",
                                 @"startStr":start,
                                 @"endStr":end,
                                 @"guestScore":@"0",
                                 @"hostScore":@"0",
                                 @"teamSize":size,
                                 @"judge":judge,
                                 @"dataRecord":data,
                                 @"isPay":@"0",
                                 @"fee":total
                                 };
    
    //    MCPay *c1 = [[MCPay alloc] initWithNibName:@"MCPay" bundle:nil];
    //    [self.navigationController pushViewController:c1 animated:YES];
    
    [self showHud];
    
    [self post:@"matchfight/json/add" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            NSDictionary *data = [dict objectForKey:@"data"];
            MatchFight *model = [MTLJSONAdapter modelOfClass:[MatchFight class] fromJSONDictionary:data error:nil];
            if (model) {
                self.matchFight = model;
            }
            
            //[self.navigationController popToRootViewControllerAnimated:YES];
            
//            btnPayAlipay.hidden=NO;
//            btnPayWeiXin.hidden=NO;
            
        }
        
//        if ([dict objectForKey:@"msg"]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[dict objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            
//            [alert show];
//        }
        [self hideHud];
    }];
}

/**
 *  支付主场费用
 */
-(void)payHost
{
    
    NSString *uid = [LoginUtil getLocalUUID];
    
    if (!self.matchFight.uuid) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"mfid":self.matchFight.uuid
                                 };
    
    [self post:@"payrecord/json/payhost" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"支付成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        }
        
        
    }];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    
    if (buttonIndex==0) {
        return;
    }
    
    
    [self payHost];
    
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
