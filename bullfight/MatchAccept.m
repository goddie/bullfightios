//
//  MCPay.m
//  bullfight
//  应战
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <AlipaySDK/AlipaySDK.h>
#import "MatchAccept.h"
#import "MCPayCell.h"
#import "MCPayTotalCell.h"
#import "MCPayCouponCell.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"
#import <math.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"

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
    
    NSNumber *payType;
    NSDictionary *orderDict;
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
 *  还剩一半没有付款的
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
    [btnPayWeiXin setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [btnPayWeiXin.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [GlobalUtil set9PathImage:btnPayWeiXin imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [parent addSubview:btnPayWeiXin];
    
    [btnPayWeiXin addTarget:self  action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    
    btnPayAlipay = [[UIButton alloc] initWithFrame:CGRectMake((w-120.0f)*0.5f, btnPayWeiXin.frame.origin.y+btnPayWeiXin.frame.size.height+20, 120.0f, 30.0f)];
    [btnPayAlipay setTitle:@"微信支付" forState:UIControlStateNormal];
    [btnPayAlipay.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [GlobalUtil set9PathImage:btnPayAlipay imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [parent addSubview:btnPayAlipay];
    [btnPayAlipay addTarget:self  action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    
    btnPayAlipay.hidden = YES;
    
    
    NSString *msg= @"1、支付完成后，来斗牛将会打电话确认。\n2、如最后没有球队应战，来斗牛将会在48小时内退回款项。\n3、如对赛事有什么特殊需求，请拨打来斗牛客服电话010-82566150。";
    UILabel *labMsg =  [[UILabel alloc] initWithFrame:CGRectMake((w-300.0f)*0.5f, btnPayAlipay.frame.origin.y+btnPayAlipay.frame.size.height+20, 300, 120)];
    labMsg.text = msg;
    labMsg.numberOfLines = 10;
    labMsg.textColor = [UIColor whiteColor];
    labMsg.font = [UIFont systemFontOfSize:14.0f];
    
    [parent addSubview:labMsg];
    
    return parent;

}

-(void)btn1Click
{
    payType = [NSNumber numberWithInteger:2];
    [self newOrder:1];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付确认" message:@"您将使用支付宝支付费用" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确认", nil];
//    alert.tag = 100;
//    [alert show];

}


-(void)btn2Click
{
    payType = [NSNumber numberWithInteger:1];
    [self newOrder:2];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付确认" message:@"您将使用微信支付费用" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确认", nil];
//    alert.tag=200;
//    [alert show];
}



/**
 *  创建订单
 *
 *  @param type 1 支付宝 2微信
 */
-(void)newOrder:(NSInteger)type
{
    NSString *uid = [self checkLogin];
    NSString *total = [NSString stringWithFormat:@"%.f",totalPay];
    if (total.length==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入购买金额" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    NSString *name = [self.matchFight.arena objectForKey:@"name"];
    NSDictionary *parameters = @{
                                 @"mfid":self.matchFight.uuid,
                                 @"uid":uid,
                                 @"name":name,
                                 @"total":total,
                                 @"payType":payType
                                 };
    [self showHud];
    [self post:@"order/json/add" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            orderDict = [[dict objectForKey:@"data"] mutableCopy];
            if (type==1) {
                [self addOrder];
            }
            if (type==2) {
                //[self addOrderWX];
            }
            
        }
        [self hideHud];
    }];
}



-(void)addOrder
{
    
    
    NSString *partner = @"2088911907194201";
    NSString *seller = @"2088911907194201";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALz/UeE0KA7eCZXqWxIfJV+V+zif/4qvUCGvw6XibyZvpVQpEUMclaKGKX2ih7kkqjNZv5yt/Txoyi37BVgTq3kUl9zBLplSElrWp8u631S9UZUtnRD2Mc4dpbdvOWVWi3Kn4GooxMnT9C4g1ILZcRtIpKpx2iH4cbepIjigxAoXAgMBAAECgYEAu/NU5BbQN2jMM5AqHS1oJ1SpzrgekzahA78dXByA2MJyse1dQ1Zr4IJ3RH+bZZ12vTZlfVTx319+oJdfyyVUgY+rXdYu0MLdVRzqPBVVEjWTTwScwyTSjehlIMT5Gprf08PzfzeADwBwP3+oihOKsCP42HK23z/UhsZKj2/uwYECQQDwRx7geCVA/sByTXnCdPgFvxeHOccukoVRUuJYr4xZXlRemOxUwyIInsig44hehrbJs+a9xpI848QTpTone81hAkEAyV0z/i96QibntW+hGr/B7gwA4gnbkC8xkIU7MNEiNr4WpLF+jglwTFyZv+to3u8PafgfsJdQEtWYSZJO4n7SdwJAOvu6gK/9tS7UXzrVoP7Fw+NdCz0LwEsHnycRmWO+uFGHtJElsskUGbmg1p4EY+/9/xXCluOgEoJ3J7tvwzGJAQJAO6QKaUgAqyVAzeFxUy3mr64IeOq4iH0h7g84F95phtNIe6FCvakYBNYMh+ae2iDubNGb+T7n7ZwsDeZyzO0JQwJBAJJLWKFqNP+j1hXdpY+o4HOh5oTGqa8li5CTszDjE/dSepyYn1QbSOBdtCN6tvNsLahntw/SZfT20ffVzey4434=";
    
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [orderDict objectForKey:@"tradeNo"]; //订单ID(由商家□自□行制定)
    order.productName = [orderDict objectForKey:@"name"]; //商品标题
    order.productDescription = [orderDict objectForKey:@"info"]; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",totalPay]; //商 品价格
    //order.amount = @"0.01";
    order.notifyURL = [baseURL stringByAppendingString:@"order/notice/alipayguest"]; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"bullfight";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description]; NSLog(@"orderSpec = %@",orderSpec);
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //【callback 处理支付结果】
            NSLog(@"reslut = %@",resultDic);
            
            
            if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
                
                [self payGuest];
                
            }
            
        }];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    
    if (buttonIndex==0) {
        return;
    }
    
    
    [self addOrder];
    

    
}


-(void)payGuest
{
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
