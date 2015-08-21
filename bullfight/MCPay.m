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

@interface MCPay ()

@end

@implementation MCPay
{
    NSArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArr = @[@[@"3vs3比赛场地费用",@"¥20"],@[@"3vs3比赛裁判费用",@"¥10"],@[@"3vs3比赛数据员费用",@"¥30"],@[@"费用总计",@"¥300"]];
    
    self.view.backgroundColor = [GlobalConst appBgColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIView*)getFoot
{
    float w = self.view.frame.size.width;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 200)];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake((w-120.0f)*0.5f, 10.0f, 120.0f, 30.0f)];
    [btn1 setTitle:@"微信支付" forState:UIControlStateNormal];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [GlobalUtil set9PathImage:btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [parent addSubview:btn1];
    
    [btn1 addTarget:self  action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake((w-120.0f)*0.5f, 50.0f, 120.0f, 30.0f)];
    [btn2 setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [GlobalUtil set9PathImage:btn2 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [parent addSubview:btn2];
    [btn2 addTarget:self  action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    
    return parent;
}

-(void)btn1Click
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付确认" message:@"您将使用支付宝支付300元" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确认", nil];
    alert.tag = 100;
    [alert show];
}


-(void)btn2Click
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付确认" message:@"您将使用微信支付300元" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确认", nil];
    alert.tag=200;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",buttonIndex);
    
    if (buttonIndex==0) {
        return;
    }
    
    NSString *uuid = [LoginUtil getLocalUUID];
    if (uuid.length==0) {
        return;
    }
    
    
    NSDictionary *parameters = @{
                                 @"uid":uuid,
                                 @"mfid":self.matchFight.uuid
                                 };
    
    MCPay *c1 = [[MCPay alloc] initWithNibName:@"MCPay" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
    
    [self post:@"matchfight/json/accept" params:parameters success:^(id responseObj) {
        
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
