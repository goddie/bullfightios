//
//  MatchWildTop.m
//  bullfight
//
//  Created by goddie on 15/8/28.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchWildTop.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "LoginUtil.h"
#import "JoinList.h"
#import "MyButton.h"
#import "MIController.h"
 

@interface MatchWildTop ()

@end

@implementation MatchWildTop
{
    NSMutableArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    dataArr = [NSMutableArray arrayWithCapacity:10];
    
    self.title = @"野球比赛";
    [GlobalUtil set9PathImage:self.btnApp imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    if ([self.matchFight.status intValue]==2) {
        [self.btnApp setTitle:@"已结束" forState:UIControlStateNormal];
        [self.btnApp setUserInteractionEnabled:NO];
    }
    
    [self loadData];
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

- (IBAction)btnTotalClick:(id)sender {
    
    JoinList *c1 = [[JoinList alloc] initWithNibName:@"JoinList" bundle:nil];
    c1.matchFight = self.matchFight;
    [self.navigationController pushViewController:c1 animated:YES];
}


- (IBAction)btnAppClick:(id)sender {
    
    NSString *uid = [LoginUtil getLocalUUID];
    
    if (!uid) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"mfid":self.matchFight.uuid,
                                 @"uid":uid
                                 };
    [self showHud];
    [self post:@"matchfightuser/json/join" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            [self.btnApp setTitle:@"已报名" forState:UIControlStateNormal];
            [self.btnApp setUserInteractionEnabled:NO];
            
        }
        
        if ([dict objectForKey:@"msg"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        [self hideHud];
        [self loadData];
    }];
}


-(void)loadData
{
    [self showHud];
    [dataArr removeAllObjects];
    NSDictionary *parameters = @{
                                 @"mfid":self.matchFight.uuid,
                                 @"count":@"6"
                                 };
    
    [self post:@"matchfightuser/json/listuser" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
            NSError *error = nil;
            
            for (NSDictionary *data in arr) {
                User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
                //                NSLog(@"%@",[error description]);
                if (model!=nil) {
                    [dataArr addObject:model];
                }
            }
            
            [self initUserList];
        }
        
        [self hideHud];
    }];
    
    
    
    //是否已报名
    
    NSString *uid = [LoginUtil getLocalUUID];
    
    if (!uid) {
        return;
    }
    
    NSDictionary *parameters2 = @{
                                 @"mfid":self.matchFight.uuid,
                                 @"uid":uid
                                 };
    
    [self post:@"matchfightuser/json/isjoin" params:parameters2 success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            [self.btnApp setTitle:@"已报名" forState:UIControlStateNormal];
            [self.btnApp setUserInteractionEnabled:NO];
            
        }
        
    }];

}

-(void)openMember:(MyButton*)sender
{
    MIController *c1 = [[MIController alloc] initWithNibName:@"MIController" bundle:nil];
    
    c1.user = (User*)sender.data;
    
    [self.navigationController pushViewController:c1 animated:YES];
}

/**
 *  已报名头像
 */
-(void)initUserList
{
    if (dataArr.count==0) {
        return;
    }
    
    int w = 30;
    int s = 8;
    
    int screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    int totalw = 0;
    
    [self.btnTotal setTitle: [NSString stringWithFormat:@"%d人报名>",dataArr.count] forState:UIControlStateNormal];
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    
    for (int i=0; i<dataArr.count; i++) {
        
        int x = i * w + s*i;
        
        User *user = [dataArr objectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 5, w, w)];
        imageView.image = [UIImage imageNamed:@"holder.png"];
        [GlobalUtil setMaskImageQuick:imageView withMask:@"shared_avatar_mask_small.png" point:CGPointMake(w, w)];
        if (user.avatar) {
            NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:user.avatar]];
            [imageView sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
        }
        
        
        [parent addSubview:imageView];
        
        [GlobalUtil addButtonToView:self sender:imageView action:@selector(openMember:) data:user];
        
        
    }
    
    totalw = ( w + s ) * dataArr.count - s;
    parent.frame = CGRectMake((self.holder.frame.size.width - totalw)*0.5f, 0, totalw, 40);
    
    
    [self.holder addSubview:parent];
//    self.holder.backgroundColor = [UIColor redColor];
//    parent.backgroundColor = [UIColor yellowColor];
}


@end
