//
//  LeagueJoin.m
//  bullfight
//  参加联赛
//  Created by goddie
//  Copyright © 2016年 santao. All rights reserved.
//
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "DataSigner.h"
#import "LeagueJoin.h"
#import "MCTeamList.h"
#import "MCTeam.h"
#import "LoginUtil.h"

#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"
#import "Order.h"

@interface LeagueJoin ()

@end

@implementation LeagueJoin
{
    Team *team;
    User *user;
    NSNumber *payType;
    NSDictionary *orderDict;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入联盟";
    self.view.backgroundColor = [GlobalConst appBgColor];
    
    
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(78.0f, 78.0f)];
    [GlobalUtil addButtonToView:self sender:self.img1 action:@selector(chooseTeam) data:nil];

    
    [self getData];
    
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


-(void)chooseTeam
{
    MCTeamList *c1 = [[MCTeamList alloc] initWithNibName:@"MCTeamList" bundle:nil];
    
    //    self.navigationController.delegate = c1;
    
    [self.navigationController pushViewController:c1 animated:YES];
    
}


/**
 *  绑定数据
 */
-(void)bindData
{
    
    [self getUserData];
    
    self.txt3.text = [GlobalUtil toFloatString:self.league.fee];
}


-(void)getUserData
{
    NSString *uid = [LoginUtil getLocalUUID];
    if (!uid) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uid
                                 };
    [self showHud];
    
    [self post:@"user/json/getuser" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [dict objectForKey:@"data"];
            NSError *error = nil;
            User *entity = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
            
            //NSLog(@"%@",[error description]);
            
            if (entity!=nil) {
                user = entity;
                
                self.txt2.text = user.phone;
                
            }
            
            
        }
        
        [self hideHud];
    }];
}



-(void)getData
{
    NSString *uuid = [LoginUtil getLocalUUID];
    if (!uuid.length) {
        return;
    }
    
    [self bindData];
    
    
    
    
    NSDictionary *parameters = @{
                                 @"uid":uuid
                                 
                                 };
    
    
    
    __weak LeagueJoin * wself = self;
    
    [self showHud];
    [self post:@"teamuser/json/mymanateam" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
            NSError *error = nil;
            
            
            if (arr.count) {
                
                NSDictionary *data = [arr firstObject];
                
                Team *model = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:data error:&error];
                
                if (model!=nil) {
                    
                    team = model;
                    [wself bindTeam];
                    
                }
                
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有球队" message:@"您没有自己的球队，是否创建球队?" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"创建球队", nil];
                alert.tag = 200;
                [alert show];
            }
            
            [self hideHud];
        }
    }];
    
}
    
-(void)bindTeam
{
    if (!team) {
        return;
    }

    
    if(team.avatar)
    {
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:team.avatar]];
        [self.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
    
    self.txtTeamName.text = team.name;
}




- (IBAction)btn1Click:(id)sender {
    
    if (self.league.isOpen==0) {
        
        UIAlertView *alert=  [[UIAlertView alloc]initWithTitle:@"失败" message:@"该联赛不接受公开报名" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付报名费" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alipay = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        payType = [NSNumber numberWithInt:1];
        [self newOrder:1];
    }];
    
//    UIAlertAction *wxpay = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        payType = [NSNumber numberWithInt:2];
//        [self newOrder:2];
//    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:alipay];
//    [alertController addAction:wxpay];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];

}


-(void)payLeagueTeam
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"参加成功!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popoverPresentationController];
    }];
    

    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    

}



/**
 *  创建订单
 *
 *  @param type 1 支付宝 2微信
 */
-(void)newOrder:(NSInteger)type
{
    NSString *uid = [self checkLogin];
    NSString *total = [NSString stringWithFormat:@"%.f",[self.league.fee floatValue]];

    NSString *name = [self.league.name stringByAppendingString:@"报名费"];
    NSDictionary *parameters = @{
                                 @"teamId":team.uuid,
                                 @"leagueId":self.league.uuid,
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
                [self addOrderWX];
            }
            
        }
        [self hideHud];
    }];
}



-(void)addOrderWX
{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = @"wx230f8507faa698a0";
    request.prepayId= @"1101000000140415649af9fc314aa427";
    request.package = @"Sign=WXPay";
    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
    request.timeStamp= 1397527777;
    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    [WXApi sendReq:request];
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
    //order.amount = [NSString stringWithFormat:@"%.2f",[self.league.fee floatValue]]; //商 品价格
    order.amount = @"0.01";
    order.notifyURL = [baseURL stringByAppendingString:@"order/notice/alipayleague"]; //回调URL
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
                
                [self payLeagueTeam];
                
            }else
            {
                
                
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付遇到问题!" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
                
                
                [alertController addAction:cancel];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        }];
    }
}




@end
