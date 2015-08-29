//
//  MatchWild.m
//  bullfight
//
//  Created by goddie on 15/8/28.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchWild.h"
#import "MatchWildTop.h"
#import "MFMatchInfoCell.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"

@interface MatchWild ()

@end

@implementation MatchWild

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"野球娱乐场";
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
                      @[@50],
                      @[@80]
                      ];
    topHeight =240;
    cellArr = @[
                @[@"MFMatchInfoCell"],
                @[@"MFMessageCell"]
                
                ];
    
    cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:0];
    
    dataArr1 = [NSMutableArray arrayWithCapacity:10];
    dataArr2 = [NSMutableArray arrayWithCapacity:10];
}



-(UIView*)getTop
{
    if(sectionHeader)
    {
        return sectionHeader;
    }
    
    MatchWildTop *top = [[MatchWildTop alloc] initWithNibName:@"MatchWildTop" bundle:nil];
    [self addChildViewController:top];
    top.topDelegate = self;
    top.matchFight = self.matchFight;
    top.topDelegate = self;
    
    sectionHeader = top.view;
    
    return sectionHeader;
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

        
        [dataArr1 addObject:@[@"shared_icon_location.png",[self.matchFight.arena objectForKey:@"name"]]];
        [dataArr1 addObject:@[@"shared_icon_time.png",[GlobalUtil toString:[GlobalUtil getDateFromUNIX:self.matchFight.start]]]];
        
        [dataArr1 addObject:@[@"shared_icon_weather.png",[GlobalUtil toString:self.matchFight.weather]]];
        
        
        [self.tableView reloadData];
    }
    
    
    //评论
    if (tabIndex==1) {
        
        
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
    
    /**
     *  比赛数据
     */
    if (tabIndex==0) {
        
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
