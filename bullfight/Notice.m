//
//  Notice.m
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "Notice.h"
#import "NoticeCell.h"
#import "UIViewController+Custome.h"
#import "Message.h"
#import "MatchFight.h"
#import "MFWildController.h"
#import "MEController.h"
#import "MFController.h"
#import "Team.h"


@interface Notice ()

@end

@implementation Notice
{
    NSMutableArray *dataArr;
    //NSMutableArray *dataArr2;
    NSMutableArray *dataArr3;
    Team *curTeam;
    Message *curMessage;
    NSNumber *curPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    dataArr =  [NSMutableArray arrayWithCapacity:10];
    //dataArr2 =  [NSMutableArray arrayWithCapacity:10];
    dataArr3 =  [NSMutableArray arrayWithCapacity:10];
 
    
    self.title = @"消息";
    
    
    curPage = [NSNumber numberWithInt:1];
    __weak Notice *wkSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [wkSelf refresh];
        
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [wkSelf loadMore];
        
    }];
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)refresh
{
    [dataArr removeAllObjects];
    curPage = [NSNumber numberWithInt:1];
    [self loadData];
}

-(void)loadMore
{
    curPage = [NSNumber numberWithInt: [curPage intValue] + 1];
    
    [self loadData];
}

-(void)stopAnimation
{
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView.infiniteScrollingView stopAnimating];
    [self hideHud];
}


-(void)loadData
{
    NSString *uuid = [LoginUtil getLocalUUID];
    
    if(uuid == nil)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uuid,
                                 @"p":curPage
                                 };
    [self showHud];
    
    [self post:@"message/json/usermessage" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            NSArray *arr = [dict objectForKey:@"data"];
            NSError *error = nil;
            
            for (NSDictionary *data in arr) {
                
                
                Message *model = [MTLJSONAdapter modelOfClass:[Message class] fromJSONDictionary:data error:&error];
                
                //                NSLog(@"%@",[error description]);
                
                if (model!=nil) {
                    [dataArr addObject:model];
                }
                
                if ([model.type intValue]==1) {
                    
                    NSDictionary *dc = [data objectForKey:@"matchFight"];
                    MatchFight *model2 = [MTLJSONAdapter modelOfClass:[MatchFight class] fromJSONDictionary:dc error:&error];
                    if (model2!=nil) {
                        
                        [dataArr3 addObject:model2];
                        
                    }

                }
                
                if ([model.type intValue]==2) {
                    
                    
                    NSDictionary *dc = [data objectForKey:@"team"];
                    Team *model2 = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:dc error:&error];
                    if (model2!=nil) {
                        
                        [dataArr3 addObject:model2];
                        
                    }
                    
                }
                
                
            }

            [self.tableView reloadData];
            
            [self stopAnimation];
        }
        
    }];

}


-(void)accept
{
    
    NSString *uuid = [LoginUtil getLocalUUID];
    
    if(!uuid)
    {
        return;
    }
    
    if(!curTeam)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uuid,
                                 @"tid":curTeam.uuid
                                 };
    
    __weak Notice * wself = self;
    [self post:@"teamuser/json/join" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            [self.tableView reloadData];
            
            
        }
        

        if ([dict objectForKey:@"msg"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        [wself delete:curMessage.uuid];
        
    }];

}


-(void)delete:(NSString*)mid
{
    NSString *uuid = [LoginUtil getLocalUUID];
    
    if(!uuid)
    {
        return;
    }
    
    
    NSDictionary *parameters = @{
                                 @"uid":uuid,
                                 @"mid":mid
                                 };
    
    
    [self post:@"message/json/delete" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            [self.tableView reloadData];
        }
        
    }];

}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    if (alertView.tag==100) {
        if (buttonIndex==0) {
            return ;
        }
        
        if (buttonIndex==1) {
            [self accept];
        }
    }
}

/**
 *  标记已读
 *
 *  @param message <#message description#>
 */
-(void)updateRead:(Message*)message
{
    
    NSDictionary *parameters = @{
                                 @"mid":message.uuid
                                 };
    
    [self post:@"message/json/updateread" params:parameters success:^(id responseObj) {
        
//        NSDictionary *dict = (NSDictionary *)responseObj;
        
//        if ([[dict objectForKey:@"code"] intValue]==1) {
//            
//            [self.tableView reloadData];
//            
//            
//        }
        
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 62.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NoticeCell";
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    if (dataArr.count==0) {
        return cell;
    }
    
    Message *entity = (Message*)[dataArr objectAtIndex:indexPath.row];
    
    cell.txtTime.text = [GlobalUtil getDateFromUNIX:entity.createdDate];
    cell.txtContent.text = entity.title;
    
    if ([entity.status intValue]==1) {
        cell.imgreg.hidden=YES;
    }else
    {
        cell.imgreg.hidden=NO;
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Message *entity = (Message*)[dataArr objectAtIndex:indexPath.row];
    
    [self updateRead:entity];
    
    
    NoticeCell *cell = (NoticeCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgreg.hidden = YES;
    
    curMessage = entity;
    
    if ([entity.type intValue]==1) {
        
        MatchFight *mf = [dataArr3 objectAtIndex:indexPath.row];
        int s = [mf.status intValue];
        if (s==0) {
            
            MFWildController *c1 = [[MFWildController alloc] initWithNibName:@"MFWildController" bundle:nil];
            c1.matchFight = mf;
            
            [self.navigationController pushViewController:c1 animated:YES];
            
        }
        
        if (s==1) {
            MFController *c1 = [[MFController alloc] initWithNibName:@"MFController" bundle:nil];
            c1.matchFight = mf;
            [self.navigationController pushViewController:c1 animated:YES];
        }
        
        if (s==2){
            MEController *c1 = [[MEController alloc] initWithNibName:@"MEController" bundle:nil];
            c1.matchFight = mf;
            [self.navigationController pushViewController:c1 animated:YES];
        }

    }
    
    if ([entity.type intValue]==2)
    {
        curTeam = (Team*)[dataArr3 objectAtIndex:indexPath.row];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邀请入队" message:entity.content delegate:self cancelButtonTitle:@"暂不加入" otherButtonTitles:@"加入队伍", nil];
        
        alert.tag = 100;
        
        [alert show];
    }
    
    
}



@end
