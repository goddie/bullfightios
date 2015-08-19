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

@interface MIController ()

@end

@implementation MIController

{
    NSArray *cellArr;
    NSInteger tabIndex;
    NSString *cellIdentifier;
    NSArray *dataArr;
    NSArray *cellHeightArr;
    MITop *top;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor  = [GlobalConst lightAppBgColor];
    
    top = [[MITop alloc] initWithNibName:@"MITop" bundle:nil];
    [self addChildViewController:top];
    top.parent = self;
    
    cellHeightArr = @[@210,@62,@210];
    cellArr = @[@"MIMemberCell",@"TITeamDataCell",@"MIMemberCell"];
    dataArr = @[@[@"1"],
                @[@[@"场均得分",@10,@"命中率",@"4%"],@[@"场均三分",@30,@"命中率",@"54%"],@[@"场均篮板",@10,@"场均助攻",@11]],
                @[@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了"]];
    tabIndex = 0;
    
    cellIdentifier = [cellArr objectAtIndex:tabIndex];
    
    
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
        
        MIMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        //cell.txt1.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        
        return cell;
        
    }
    
    if (tabIndex==1) {
        
        TITeamDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        // cell.txtName.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        
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



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 323.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return top.view;
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
