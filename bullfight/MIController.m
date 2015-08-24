//
//  MIController.m
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MIController.h"
#import "MITop.h"
#import "MIMemberCell.h"
#import "TITeamDataCell.h"
#import "MyDataCell.h"
#import "UIImageView+WebCache.h"

@interface MIController ()

@end

@implementation MIController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
 
    
//    cellHeightArr = @[@210,@62,@210];
//    cellArr = @[@"MIMemberCell",@"TITeamDataCell",@"MIMemberCell"];
//    dataArr = @[@[@"1"],
//                @[@[@"场均得分",@10,@"命中率",@"4%"],@[@"场均三分",@30,@"命中率",@"54%"],@[@"场均篮板",@10,@"场均助攻",@11]],
//                @[@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了"]];
//    tabIndex = 0;
//    
//    cellIdentifier = [cellArr objectAtIndex:tabIndex];
    
    self.title = self.user.nickname;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)reminder
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
                      @[@210],
                      @[@62],
                      @[@210]
                      ];
    topHeight =323;
    cellArr = @[
                @[@"MIMemberCell"],
                @[@"MyDataCell"],
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
    
    MITop *top = [[MITop alloc] initWithNibName:@"MITop" bundle:nil];
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
        
        [dataArr1 addObject:self.user];
        
        [self.tableView reloadData];
    }
    
    
    //球队数据
    if (tabIndex==1) {
        
        if([dataArr2 count])
        {
            [self.tableView reloadData];
            return;
        }
        
        
        [dataArr2 addObject:@[@[@"场均得分",[GlobalUtil toString:self.user.scoring]],@[@"投篮命中率",[GlobalUtil toString:self.user.goalPercent]]]];
        [dataArr2 addObject:@[@[@"三分球命中率",[GlobalUtil toString:self.user.threeGoalPercent]],@[@"场均犯规",[GlobalUtil toString:self.user.goalPercent]]]];
        [dataArr2 addObject:@[@[@"场均篮板",[GlobalUtil toString:self.user.goalPercent]],@[@"场均助攻",[GlobalUtil toString:self.user.goalPercent]]]];
        [dataArr2 addObject:@[@[@"场均失误",[GlobalUtil toString:self.user.goalPercent]],@[@"场均抢断",[GlobalUtil toString:self.user.goalPercent]]]];
        
        [self.tableView reloadData];
        
    }
    
    //阵容
    if (tabIndex==2) {
        
        
        
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
        
        MIMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        
        cell.txtBirthday.text = self.user.birthday;
        cell.txtHeight.text = [GlobalUtil toString:self.user.height];
        cell.txtPos.text = self.user.position;
        cell.txtWeight.text = [GlobalUtil toString:self.user.weight];
        
        //cell.txt1.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        if(self.user.avatar)
        {
            NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.user.avatar]];
            [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
        }
        
        return cell;
        
    }
    
    if (tabIndex==1) {
        
        MyDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        cell.lab1.text = [[[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:0] objectAtIndex:0];
        cell.txt1.text = [[[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:0] objectAtIndex:1];
        
        cell.lab2.text = [[[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:1] objectAtIndex:0];
        cell.txt2.text = [[[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:1] objectAtIndex:1];
        
        
        return cell;
        
    }
    
    
    if (tabIndex==2) {
        
        MIMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    
    return nil;
}

@end
