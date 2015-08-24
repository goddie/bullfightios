//
//  MFController.m
//  bullfight
//  未开始
//  Created by goddie on 15/8/8.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MFController.h"
#import "MFTop.h"
#import "MFMatchInfoCell.h"
#import "MFTeamInfoTopCell.h"
#import "MFMemberCell.h"
#import "MFMessageCell.h"
#import "TIController.h"
#import "MIController.h"
#import "MyButton.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "MFMatchNoticeCell.h"
#import "MFTeamInfoCell.h"
#import "MTLJSONAdapter.h"
#import <math.h>
#import "MatchDataUser.h"

@interface MFController ()

@end

@implementation MFController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    

//    cellHeightArr = @[@44,@80,@160,@160];
//    cellArr = @[@"MFMatchInfoCell",@"MFTeamInfoTopCell",@"MFMemberCell",@"MFMessageCell"];
//    dataArr = @[@[@"东单体育中心18号场地",@"12月28日 14:00-15:30",@"晴转多云",@"裁判员一名，数据员两名",@"接受系统赛前通知提醒"],
//                @[@"场均得分",@"场均篮板",@"场均助攻",@"场均失误",@"场均盖帽"],
//                @[@"后卫",@"中锋",@"前锋"],
//                @[@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了"]];
//    tabIndex = 0;
//    
//    cellIdentifier = [cellArr objectAtIndex:tabIndex];
//    
//    self.tableView.backgroundColor  = [GlobalConst lightAppBgColor];
//
//    [self bindData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchView:(id)sender{
    
    UISegmentedControl *control = (UISegmentedControl *)sender;
    tabIndex = control.selectedSegmentIndex;
    cellIdentifier = [cellArr objectAtIndex:tabIndex];
    [self.tableView reloadData];
    
}



-(void)initData
{
    cellHeightArr = @[
                      @[@44],
                      @[@80],
                      @[@160],
                      @[@160]
                      ];
    topHeight =180;
    cellArr = @[
                @[@"MFMatchInfoCell",@"MFMatchNoticeCell"],
                @[@"MFTeamInfoCell",@"MFTeamInfoTopCell"],
                @[@"MFMemberCell"],
                @[@"MFMessageCell"]
                
                ];
    
    cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:0];
    
    dataArr1 = [NSMutableArray arrayWithCapacity:10];
    dataArr2 = [NSMutableArray arrayWithCapacity:10];
    dataArr3 = [NSMutableArray arrayWithCapacity:10];
    dataArr4 = [NSMutableArray arrayWithCapacity:10];
}



-(UIView*)getTop
{
    if(sectionHeader)
    {
        return sectionHeader;
    }
    
    MFTop *top = [[MFTop alloc] initWithNibName:@"MFTop" bundle:nil];
    [self addChildViewController:top];
    top.team = self.team;
    top.matchFight = self.matchFight;
    top.topDelegate =self;
    
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
    //比赛信息
    if (tabIndex==0) {
        if([dataArr1 count])
        {
            [self.tableView reloadData];
            return;
        }
        
        
        NSString *s1 = [NSString stringWithFormat:@"裁判员%@名，数据员%@名",
                        [GlobalUtil toString:self.matchFight.judge],
                        [GlobalUtil toString:self.matchFight.dataRecord]];
        
        [dataArr1 addObject:@[@"shared_icon_location.png",[self.matchFight.arena objectForKey:@"name"]]];
        [dataArr1 addObject:@[@"shared_icon_time.png",[GlobalUtil getDateFromUNIX:self.matchFight.start]]];
        [dataArr1 addObject:@[@"shared_icon_weather.png",self.matchFight.weather]];
        [dataArr1 addObject:@[@"shared_icon_jurge.png",s1]];
        [dataArr1 addObject:@[@"shared_icon_notification.png",@"接受系统赛前通知提醒"]];
        
        [self.tableView reloadData];

    }
    
    
    //球队数据
    if (tabIndex==1) {
        
        if([dataArr2 count])
        {
            [self.tableView reloadData];
            return;
        }
        
        NSDictionary *hdict = self.matchFight.host;
        Team *host = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:hdict error:nil];
        
        NSDictionary *hdict2 = self.matchFight.host;
        Team *guest = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:hdict2 error:nil];
        
        
        
        
        [dataArr2 addObject:@[@"历史战绩",[GlobalUtil toString:host.playCount],[GlobalUtil toString:host.win],[GlobalUtil toString:guest.playCount],[GlobalUtil toString:guest.win]]];
        [dataArr2 addObject:@[@"场均得分",[GlobalUtil toString:host.scoring],[GlobalUtil toString:guest.scoring]]];
        [dataArr2 addObject:@[@"场均篮板",[GlobalUtil toString:host.rebound],[GlobalUtil toString:guest.rebound]]];
        [dataArr2 addObject:@[@"场均助攻",[GlobalUtil toString:host.assist],[GlobalUtil toString:guest.assist]]];
        [dataArr2 addObject:@[@"场均失误",[GlobalUtil toString:host.turnover],[GlobalUtil toString:guest.turnover]]];
        [dataArr2 addObject:@[@"场均盖帽",[GlobalUtil toString:host.block],[GlobalUtil toString:guest.block]]];

        
        
        [self.tableView reloadData];
        
        
        
    }
    
    //阵容
    if (tabIndex==2) {
        
        NSString *hostid = [self.matchFight.host objectForKey:@"id"];
        NSString *guestid = [self.matchFight.guest objectForKey:@"id"];
        
        NSDictionary *parameters = @{
                                     @"hostid":hostid,
                                     @"guestid":guestid,
                                     @"p":@"1"
                                     };
        [dataArr3 removeAllObjects];
        
        [self post:@"teamuser/json/memberlistboth" params:parameters success:^(id responseObj) {
            NSDictionary *dict = (NSDictionary *)responseObj;
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arrBig = [dict objectForKey:@"data"];
                NSError *error = nil;
                
                NSArray *arr1 =[arrBig objectAtIndex:0];
                NSArray *arr2 =[arrBig objectAtIndex:1];
                
                NSMutableArray *marr1 = [NSMutableArray arrayWithCapacity:10];
                NSMutableArray *marr2 = [NSMutableArray arrayWithCapacity:10];
                
                for (NSDictionary *data in arr1) {
                    User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
                    if (model!=nil) {
                        [marr1 addObject:model];
                    }
                }
                
                for (NSDictionary *data in arr2) {
                    User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
                    if (model!=nil) {
                        [marr2 addObject:model];
                    }
                }
                
                int size =  fmin(marr1.count,marr2.count);
                for (int i=0; i<size; i++) {
                    
                    
                    NSArray *tmp =[ NSArray arrayWithObjects:[marr1 objectAtIndex:i],[marr2 objectAtIndex:i], nil];
                    
                    [dataArr3 addObject: tmp];
                    
                }
                
                if (marr1.count>marr2.count) {
                    
                    [dataArr3 addObject:@[[marr1 lastObject],[NSNull null]]];
                }
                
                if (marr2.count>marr1.count)
                {
                    [dataArr3 addObject:@[[NSNull null],[marr2 lastObject]]];
                }
                
                
                
                
            }
            [self.tableView reloadData];
        }];
        
        
    }
    
    //荣誉
    if (tabIndex==3) {
        
    }
}


-(void)openMember:(id)sender
{
    MyButton *btn = (MyButton*)sender;
    
    MIController *c1 = [[MIController alloc] initWithNibName:@"MIController" bundle:nil];
    
    [self.navigationController pushViewController:c1 animated:YES];
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h  =[[[cellHeightArr objectAtIndex:tabIndex] objectAtIndex:0] intValue];
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:0];

    if (tabIndex==0) {
        
        if (indexPath.row==4) {
            
            cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:1];
            
            
            MFMatchNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
                cell = [nibArray objectAtIndex:0];
            }
            
            cell.txt1.text = [[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:1];
            cell.img1.image = [UIImage imageNamed:[[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:0]];
            
            return cell;
        }
        
        
 
        MFMatchInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        cell.txt1.text = [[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:1];
        cell.img1.image = [UIImage imageNamed:[[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:0]];
        
        return cell;

    }
    
    if (tabIndex==1) {
        
        

        
        if(indexPath.row==0)
        {
            cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:1];
            
            MFTeamInfoTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
                cell = [nibArray objectAtIndex:0];
            }
            
            cell.txtName.text = [[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.txtFight1.text = [[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:1];
            cell.txtWin1.text = [[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:2];
            cell.txtFight2.text = [[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:3];
            cell.txtWin2.text = [[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:4];
            return cell;
        }
        
        
        MFTeamInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        cell.txtName.text = [[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.txt1.text =[[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:1];
        cell.txt2.text = [[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:2];
        
        
        return cell;
        
    }
    
    
    if (tabIndex==2) {
        
        MFMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        if ([[dataArr3 objectAtIndex:indexPath.row] objectAtIndex:0]) {
            
            
            User *user= (User*)[[dataArr3 objectAtIndex:indexPath.row] objectAtIndex:1];
            
            cell.txtName1.text = user.nickname;
            
            if(user.avatar)
            {
                NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:user.avatar]];
                [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
            }
            
            [GlobalUtil addButtonToView:self sender:cell.img1 action:@selector(openMember:) data:user.uuid];
        }
        
        if ([[dataArr3 objectAtIndex:indexPath.row] objectAtIndex:1]) {
            
            
            User *user= (User*)[[dataArr3 objectAtIndex:indexPath.row] objectAtIndex:1];
            
            cell.txtName2.text = user.nickname;
            
            if(user.avatar)
            {
                NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:user.avatar]];
                [cell.img2 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
            }
            
            [GlobalUtil addButtonToView:self sender:cell.img2 action:@selector(openMember) data:user.uuid];
        }
        
        //cell.txtPos.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        
        
        
        return cell;
        
    }
    
    
    if (tabIndex==3) {
        
        MFMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        cell.txtContent.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        
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
    
}


@end
