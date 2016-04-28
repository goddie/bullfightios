//
//  TIController.m
//  bullfight
//  球队信息
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TIController.h"
#import "TITop.h"
#import "MatchFinishCell.h"
#import "TIPositionCell.h"
#import "TITeamDataCell.h"
#import "UIViewController+Custome.h"
#import "Team.h"
#import "UIImageView+WebCache.h"
#import "MatchFight.h"
#import "User.h"
#import "TeamDataCell.h"
#import "MIController.h"
#import "MyButton.h"
#import "MEController.h"
#import "BlankCell.h"

@interface TIController ()

@end

@implementation TIController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.team.name;
    
    [self globalConfig];
    
     self.tableView.backgroundColor  = [GlobalConst lightAppBgColor];
    
    [self initData];
    [self getTop];
    [self getData];
    
    tabIndex = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData
{
    cellHeightArr = @[
                      @[@190,@44],
                      @[@70],
                      @[@62],
                      @[@44]
                      ];
    topHeight =335;
    cellArr = @[
                @[@"MatchFinishCell",@"TeamDataCell"],
                @[@"TIPositionCell"],
                @[@"TITeamDataCell"],
                @[@"BlankCell"]
                
                ];
    
    cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:0];
 
    dataArr1 = [NSMutableArray arrayWithCapacity:10];
    dataArr2 = [NSMutableArray arrayWithCapacity:10];
    dataArr3 = [NSMutableArray arrayWithCapacity:10];
    dataArr4 = [NSMutableArray arrayWithCapacity:10];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}



-(UIView*)getTop
{
    if(sectionHeader)
    {
        return sectionHeader;
    }
    
    TITop *top = [[TITop alloc] initWithNibName:@"TITop" bundle:nil];
    top.topDelegate = self;
    top.team = self.team;
    [self addChildViewController:top];
    sectionHeader = top.view;
    
    return sectionHeader;
}


-(void)changeTab:(NSInteger)idx
{
    if(tabIndex==idx)
    {
        return;
    }
    
    tabIndex = idx;
    cellIdentifier = [cellArr objectAtIndex:tabIndex];
    [self getData];
}


-(void)getData
{
    //战绩
    if (tabIndex==0) {
 
        if (self.uuid.length==0) {
            return;
        }
        
        NSDictionary *parameters = @{
                                     @"tid":self.uuid
                                     };
        
        [dataArr1 removeAllObjects];
        [dataArr1 addObject:@"总战绩"];
        [self showHud];
        [self post:@"matchdatateam/json/teammatch" params:parameters success:^(id responseObj) {
            NSDictionary *dict = (NSDictionary *)responseObj;
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arr = [dict objectForKey:@"data"];
                NSError *error = nil;
                for (NSDictionary *data in arr) {
                    MatchFight *model = [MTLJSONAdapter modelOfClass:[MatchFight class] fromJSONDictionary:data error:&error];
//                    NSLog(@"%@",[error description]);
                    if (model!=nil) {
                        [dataArr1 addObject:model];
                    }
                }
                [self.tableView reloadData];
                [self hideHud];
            }
        }];
    }
    
    
    //阵容
    if (tabIndex==1) {
        
        if (!self.team) {
            
            return;
        }
        
        NSDictionary *parameters = @{
                                     @"tid":self.team.uuid
                                     };
        
        [dataArr2 removeAllObjects];

        [self showHud];
        
        [self post:@"teamuser/json/memberlist" params:parameters success:^(id responseObj) {
            
            NSDictionary *dict = (NSDictionary *)responseObj;
            
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arr = [dict objectForKey:@"data"];
                NSError *error = nil;
                
                for (NSDictionary *data in arr) {
                    User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
//                    NSLog(@"%@",[error description]);
                    if (model!=nil) {
                        [dataArr2 addObject:model];
                    }
                }
                [self.tableView reloadData];
                [self hideHud];
            }
            
            
        }];
    }
    
    //数据
    if (tabIndex==2) {
        
        if (dataArr3.count>0) {
            [self.tableView reloadData];
            return;
        }
        
        NSString *r1 =[GlobalUtil toPercentString:self.team.goalPercent];
        NSString *r2 =[GlobalUtil toPercentString:self.team.freeGoalPercent];
        
       
        NSString *r3 =[GlobalUtil toFloatString:self.team.rebound];
        NSString *r4 =[GlobalUtil toFloatString:self.team.assist];
        
        NSString *r5 =[GlobalUtil toFloatString:self.team.block];
        NSString *r6 =[GlobalUtil toFloatString:self.team.steal];
        
        NSString *r7 =[GlobalUtil toFloatString:self.team.turnover];
        NSString *r8 =[GlobalUtil toFloatString:self.team.foul];
        
        
        
        dataArr3 = [NSMutableArray arrayWithArray: @[
                     @[@"投篮命中率",r1,@"罚球命中率",r2],
                     @[@"场均篮板",r3,@"场均助攻",r4],
                     @[@"场均抢断",r5,@"场均盖帽",r6],
                     @[@"场均失误",r7,@"场均犯规",r8]
                     
                     ]];
        
 
        
         [self.tableView reloadData];
    }
    
    //荣誉
    if (tabIndex==3) {
        if (dataArr4.count>0) {
            [self.tableView reloadData];
            return;
        }
        
        [dataArr4 addObject:@""];
        [self.tableView reloadData];
    }
}


//-(void)getData
//{
//
//    if(!self.uuid)
//    {
//        return;
//    }
//    
//    NSDictionary *parameters = @{
//                                 @"tid":self.uuid
//                                 };
//    
//    [self post:@"team/json/getteam" params:parameters success:^(id responseObj) {
//        
//        NSDictionary *dict = (NSDictionary *)responseObj;
//        
//        if ([[dict objectForKey:@"code"] intValue]==1) {
//            
//            NSDictionary *data = [dict objectForKey:@"data"];
//            
//            _team = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:data error:nil];
//            
//        }
//        
//    }];
//
//    
//}


//-(void)bindTeam
//{
// 
//    NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:entity.avatar]];
//    [top.img sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
//    
//    
//    top.txtFound.text = [GlobalUtil getDateFromUNIX:entity.createdDate];
//    top.txtName.text = entity.name;
//    top.txtInfo.text = entity.info;
//}


-(void)openTeam1:(MyButton*)sender;
{
    TIController *c1 = [[TIController alloc] initWithNibName:@"TIController" bundle:nil];
 
    NSDictionary* dict =(NSDictionary*)sender.data;
    Team *t = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:dict error:nil];
    c1.team = t;
    c1.uuid = t.uuid;
    [self.navigationController pushViewController:c1 animated:YES];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tabIndex==0) {
        return dataArr1.count;
    }
    
    if (tabIndex==1) {
        return dataArr2.count;
    }
    
    if (tabIndex==2) {
        return dataArr3.count;
    }
    
    if (tabIndex==3) {
        return dataArr4.count;
    }
    
    
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tabIndex==0 && indexPath.row==0)
    {
        return [[[cellHeightArr objectAtIndex:tabIndex] objectAtIndex:1] intValue];
    }
    
    int h  =[[[cellHeightArr objectAtIndex:tabIndex] objectAtIndex:0] intValue];
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:0];
    
    //球队战绩
    if (tabIndex==0) {
        
        //总战绩
        if(indexPath.row==0)
        {
            cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:1];
            
            TeamDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
                cell = [nibArray objectAtIndex:0];
            }
            
            cell.txt1.text = [GlobalUtil toString:self.team.playCount];
            cell.txt2.text = [GlobalUtil toString:self.team.win];
            cell.txt3.text = [GlobalUtil toString:self.team.lose];
//            cell.txt4.text = [GlobalUtil toString:self.team.draw];
            
            
            return cell;
        }
        
        
        
        MatchFight *entity = (MatchFight*)[dataArr1 objectAtIndex:indexPath.row];
        
        MatchFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        //cell.txt1.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        cell.txtTeam1.text = [entity.host objectForKey:@"name"];
        cell.txtTeam2.text = [entity.guest objectForKey:@"name"];
        cell.txtNum1.text = [GlobalUtil toString:entity.teamSize];
        cell.txtNum2.text = [GlobalUtil toString:entity.teamSize];
        
        cell.txtPlace.text = [entity.arena objectForKey:@"name"];
        cell.txtScore.text = [NSString stringWithFormat:@"%@:%@",[GlobalUtil toString:entity.hostScore],[GlobalUtil toString:entity.guestScore]];
        cell.txtDate.text = [GlobalUtil getDateFromUNIX:entity.start];
        
        if([entity.host objectForKey:@"avatar"])
        {
            NSString *a1 = [@"" stringByAppendingString:[entity.host objectForKey:@"avatar"]];
            NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a1]];
            [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
        }
        
        
        if([entity.guest objectForKey:@"avatar"])
        {
            NSString *a2 = [@"" stringByAppendingString:[entity.guest objectForKey:@"avatar"]];
            NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a2]];
            [cell.img2 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
        }


        if ([entity.hostScore intValue]>[entity.guestScore intValue]) {
            
            if ([[entity.host objectForKey:@"id"] isEqualToString:self.team.uuid]) {
                [cell setCornerTitle:@"战胜" bgType:1];
            }else
            {
                [cell setCornerTitle:@"失败" bgType:2];
            }
            
            
        }
        
        if ([entity.hostScore intValue]==[entity.guestScore intValue]) {
            [cell setCornerTitle:@"平局" bgType:3];
        }
        
        if ([entity.hostScore intValue]<[entity.guestScore intValue]) {
            
            
            if ([[entity.host objectForKey:@"id"] isEqualToString:self.team.uuid]) {
                [cell setCornerTitle:@"战败" bgType:2];
            }else
            {
 
                [cell setCornerTitle:@"战胜" bgType:1];
            }
        }
        
        
        
        [GlobalUtil addButtonToView:self sender:cell.img1 action:@selector(openTeam1:) data:entity.host];
        [GlobalUtil addButtonToView:self sender:cell.img2 action:@selector(openTeam1:) data:entity.guest];
        
        return cell;
        
    }
    
    //阵容
    
    if (tabIndex==1) {
        
        User *entity = (User*)[dataArr2 objectAtIndex:indexPath.row];
        
        TIPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
       // cell.txtName.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        NSString *admin  = [GlobalUtil toString:[self.team.admin objectForKey:@"id"]];
        if ([admin isEqualToString:entity.uuid]) {
            cell.txtName.text = [NSString stringWithFormat:@"%@ (队长)",entity.nickname];
            cell.txtName.textColor = [UIColor redColor];
        }
        else
        {
            cell.txtName.text = entity.nickname;
        }
        
        
        
        cell.txtPos.text = entity.position;
        if([entity.weight floatValue]>0)
        {
            cell.txtWeight.text = [NSString stringWithFormat:@"体重:%@kj",[GlobalUtil toString:entity.weight]];
        }else
        {
            cell.txtWeight.text = @"体重:保密";
        }
        
        if([entity.height floatValue]>0)
        {
            cell.txtHeight.text = [NSString stringWithFormat:@"身高:%@cm",[GlobalUtil toString:entity.height]];
        }else
        {
            cell.txtHeight.text = @"身高:保密";
        }
        
        
        if(entity.avatar)
        {
            NSString *a2 = [@"" stringByAppendingString:entity.avatar];
            NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a2]];
            [cell.img1 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
        }
        
        return cell;
        
    }
    
    
    if (tabIndex==2) {
        
        TITeamDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        //cell.txtPos.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        cell.txt1.text = [[dataArr3 objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.value1.text = [[dataArr3 objectAtIndex:indexPath.row] objectAtIndex:1];
        cell.txt2.text = [[dataArr3 objectAtIndex:indexPath.row] objectAtIndex:2];
        cell.value2.text =  [[dataArr3 objectAtIndex:indexPath.row] objectAtIndex:3];
        
        return cell;
        
    }
    
    
    if (tabIndex==3) {
        
        BlankCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        //cell.txtContent.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        
        return cell;
        
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    //战绩点击
    if (tabIndex==0) {
        
        MatchFight *entity = (MatchFight*)[dataArr1 objectAtIndex:indexPath.row];
        
        MEController *c1 = [[MEController alloc] initWithNibName:@"MEController" bundle:nil];
        c1.matchFight = entity;
        c1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:c1 animated:YES];
    }
    
    
    if (tabIndex==1) {
        User *user = [dataArr2 objectAtIndex:indexPath.row];
        
        MIController *c1 = [[MIController alloc] initWithNibName:@"MIController" bundle:nil];
        
        c1.user = user;
        
        [self.navigationController pushViewController:c1 animated:YES];
    }
    

}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return topHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getTop];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    
    return nil;
}

@end
