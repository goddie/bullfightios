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

@interface MEController ()

@end

@implementation MEController
{
    NSArray *cellArr;
    NSInteger tabIndex;
    NSString *cellIdentifier;
    NSArray *dataArr;
    NSArray *cellHeightArr;
    
    METop *top;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    top = [[METop alloc] initWithNibName:@"METop" bundle:nil];
    [self addChildViewController:top];
    top.parent = self;
    
    
    cellHeightArr = @[@44,@80,@160,@160];
    cellArr = @[@"MFMatchInfoCell",@"MFTeamInfoTopCell",@"MEMemberCell",@"MFMessageCell"];
    dataArr = @[@[@"东单体育中心18号场地",@"12月28日 14:00-15:30",@"晴转多云",@"裁判员一名，数据员两名",@"接受系统赛前通知提醒"],
                @[@"场均得分",@"场均篮板",@"场均助攻",@"场均失误",@"场均盖帽"],
                @[@"后卫",@"中锋",@"前锋"],
                @[@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了"]];
    tabIndex = 0;
    
    cellIdentifier = [cellArr objectAtIndex:tabIndex];
    
    self.tableView.backgroundColor  = [GlobalConst lightAppBgColor];
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[dataArr objectAtIndex:tabIndex] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h  =[[cellHeightArr objectAtIndex:tabIndex] intValue];
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tabIndex==0) {
        
        MFMatchInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        cell.txt1.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        
        return cell;
        
    }
    
    if (tabIndex==1) {
        
        MFTeamInfoTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        //cell.txtName.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        
        return cell;
        
    }
    
    
    if (tabIndex==2) {
        
        MEMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
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



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return top.view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tabIndex==3)
    {
        return 44.0f;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (tabIndex==3)
    {
        return nil;
    }
    
    return nil;
}


@end
