//
//  MEController.m
//  bullfight
//  比赛结束
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MEController.h"
#import "METop.h"
#import "MFMatchInfoCell.h"
#import "MFTeamInfoTopCell.h"
#import "MEMemberCell.h"
#import "MFMessageCell.h"
#import "MatchDataUser.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "MFMatchNoticeCell.h"
#import "MFTeamInfoCell.h"


@interface MEController ()

@end

@implementation MEController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    cellHeightArr = @[@44,@80,@160,@160];
//    cellArr = @[@"MFMatchInfoCell",@"MFTeamInfoTopCell",@"MEMemberCell",@"MFMessageCell"];
//    dataArr = @[@[@"东单体育中心18号场地",@"12月28日 14:00-15:30",@"晴转多云",@"裁判员一名，数据员两名",@"接受系统赛前通知提醒"],
//                @[@"场均得分",@"场均篮板",@"场均助攻",@"场均失误",@"场均盖帽"],
//                @[@"后卫",@"中锋",@"前锋"],
//                @[@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了"]];
//    tabIndex = 0;
//    
//    cellIdentifier = [cellArr objectAtIndex:tabIndex];
//    
//    self.tableView.backgroundColor  = [GlobalConst lightAppBgColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)openTeam1
{
    //    TIController *c1 = [[TIController alloc] initWithNibName:@"TIController" bundle:nil];
    //    [self.navigationController pushViewController:c1 animated:YES];
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
                      @[@50],
                      @[@80],
                      @[@206],
                      @[@160]
                      ];
    topHeight =180;
    cellArr = @[
                @[@"MFMatchInfoCell",@"MFMatchNoticeCell"],
                @[@"MFTeamInfoCell",@"MFTeamInfoTopCell"],
                @[@"MEMemberCell"],
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
    
    METop *top = [[METop alloc] initWithNibName:@"METop" bundle:nil];
    [self addChildViewController:top];
    top.topDelegate = self;
    top.matchFight = self.matchFight;
    top.topDelegate = self;
    
    sectionHeader = top.view;
    
    return sectionHeader;
}


-(void)getData
{
    //战绩
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
    
    
    //阵容
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
    
    //个人数据
    if (tabIndex==2) {
        
        NSString *mfid = self.matchFight.uuid;
        
        if (!mfid) {
            return;
        }
        
        NSDictionary *parameters = @{
                                     @"mfid":mfid
                                     };
        
        
        [dataArr3 removeAllObjects];
        
        [self post:@"matchdatauser/json/userdata" params:parameters success:^(id responseObj) {
            
            NSDictionary *dict = (NSDictionary *)responseObj;
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arrBig = [dict objectForKey:@"data"];
                NSError *error = nil;
                
                NSArray *arr1 =[arrBig objectAtIndex:0];
                NSArray *arr2 =[arrBig objectAtIndex:1];
                
                NSMutableArray *marr1 = [NSMutableArray arrayWithCapacity:10];
                NSMutableArray *marr2 = [NSMutableArray arrayWithCapacity:10];
                
                for (NSDictionary *data in arr1) {
                    MatchDataUser *model = [MTLJSONAdapter modelOfClass:[MatchDataUser class] fromJSONDictionary:data error:&error];
                    if (model!=nil) {
                        [marr1 addObject:model];
                    }
                }
                
                for (NSDictionary *data in arr2) {
                    MatchDataUser *model = [MTLJSONAdapter modelOfClass:[MatchDataUser class] fromJSONDictionary:data error:&error];
                    if (model!=nil) {
                        [marr2 addObject:model];
                    }
                }
                
                NSInteger size = 0;
                
                if (marr1.count>marr2.count) {
                    size = marr2.count;
                }else
                {
                    size = marr1.count;
                }
                
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
        
        MEMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        if ([[dataArr3 objectAtIndex:indexPath.row] objectAtIndex:0]) {
            
            MatchDataUser *entity = (MatchDataUser*)[[dataArr3 objectAtIndex:indexPath.row] objectAtIndex:0];
            NSDictionary *dict = entity.user;
            User *user= (User*)[MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dict error:nil];
            
            cell.txtName1.text = user.nickname;
            
            if(user.avatar)
            {
                NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:user.avatar]];
                [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
            }
            
 
            cell.txt11.text = [GlobalUtil toString:entity.scoring];
            cell.txt12.text = [NSString stringWithFormat:@"%@/%@",[GlobalUtil toString:entity.goal],[GlobalUtil toString:entity.shot]];
            cell.txt21.text = [NSString stringWithFormat:@"%@/%@",[GlobalUtil toString:entity.threeGoal],[GlobalUtil toString:entity.threeShot]];
            cell.txt22.text = [NSString stringWithFormat:@"%@/%@",[GlobalUtil toString:entity.freeGoal],[GlobalUtil toString:entity.free]];
            cell.txt31.text = [GlobalUtil toString:entity.rebound];
            cell.txt32.text = [GlobalUtil toString:entity.assist];
            cell.txt41.text = [GlobalUtil toString:entity.block];
            cell.txt42.text = [GlobalUtil toString:entity.steal];
            cell.txt51.text = [GlobalUtil toString:entity.foul];
            cell.txt52.text = [GlobalUtil toString:entity.turnover];
            
        }
        
        if ([[dataArr3 objectAtIndex:indexPath.row] objectAtIndex:1]) {
            
            
            MatchDataUser *entity = (MatchDataUser*)[[dataArr3 objectAtIndex:indexPath.row] objectAtIndex:1];
            NSDictionary *dict = entity.user;
            User *user= (User*)[MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dict error:nil];
            cell.txtName2.text = user.nickname;
            
            if(user.avatar)
            {
                NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:user.avatar]];
                [cell.img2 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
            }
            
            
            cell.txt13.text = [GlobalUtil toString:entity.scoring];
            cell.txt14.text = [NSString stringWithFormat:@"%@/%@",[GlobalUtil toString:entity.goal],[GlobalUtil toString:entity.shot]];
            cell.txt23.text = [NSString stringWithFormat:@"%@/%@",[GlobalUtil toString:entity.threeGoal],[GlobalUtil toString:entity.threeShot]];
            cell.txt24.text = [NSString stringWithFormat:@"%@/%@",[GlobalUtil toString:entity.freeGoal],[GlobalUtil toString:entity.free]];
            cell.txt33.text = [GlobalUtil toString:entity.rebound];
            cell.txt34.text = [GlobalUtil toString:entity.assist];
            cell.txt43.text = [GlobalUtil toString:entity.block];
            cell.txt44.text = [GlobalUtil toString:entity.steal];
            cell.txt53.text = [GlobalUtil toString:entity.foul];
            cell.txt54.text = [GlobalUtil toString:entity.turnover];
 
        }

        
        
        return cell;
        
    }
    
    
    if (tabIndex==3) {
        
        MFMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
    
}


@end
