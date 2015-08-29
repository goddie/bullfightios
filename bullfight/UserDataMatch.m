//
//  MEController.m
//  bullfight
//  比赛结束
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "UserDataMatch.h"
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
#import "MyButton.h"
#import "MIController.h"
#import "UserInfoTop.h"


@interface UserDataMatch ()

@end

@implementation UserDataMatch

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单场数据";
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
 
                      @[@206]
 
                      ];
    topHeight =180;
    cellArr = @[
 
                @[@"MEMemberCell"],
 
                
                ];
    
    cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:0];
    
 
    dataArr1 = [NSMutableArray arrayWithCapacity:10];
 
}



-(UIView*)getTop
{
    if(sectionHeader)
    {
        return sectionHeader;
    }
    
    UserInfoTop *top = [[UserInfoTop alloc] initWithNibName:@"UserInfoTop" bundle:nil];
    [self addChildViewController:top];
    top.topDelegate = self;
    top.matchFight = self.matchFight;
    top.topDelegate = self;
    
    sectionHeader = top.view;
    
    return sectionHeader;
}


-(void)getData
{
    NSString *mfid = self.matchFight.uuid;
    
    if (!mfid) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"mfid":mfid
                                 };
    
    [self showHud];
    [dataArr1 removeAllObjects];
    
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
                
                [dataArr1 addObject: tmp];
                
            }
            
            if (marr1.count>marr2.count) {
                
                [dataArr1 addObject:@[[marr1 lastObject],[NSNull null]]];
            }
            
            if (marr2.count>marr1.count)
            {
                [dataArr1 addObject:@[[NSNull null],[marr2 lastObject]]];
            }
            
            
            
            
        }
        [self.tableView reloadData];
        
        [self showHud];
    }];
}

-(void)openMember:(id)sender
{
    MyButton *btn = (MyButton*)sender;
    User *data = (User*)btn.data;
    
    MIController *c1 = [[MIController alloc] initWithNibName:@"MIController" bundle:nil];
    c1.user = data;
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
    
    MEMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    if (dataArr1.count == 0) {
        return cell;
    }
    
    if ([[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:0]) {
        
        MatchDataUser *entity = (MatchDataUser*)[[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:0];
        
        if ((NSNull*)entity!=[NSNull null]) {
            NSDictionary *dict = entity.user;
            User *user= (User*)[MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dict error:nil];
            
            cell.txtName1.text = user.nickname;
            
            if(user.avatar)
            {
                NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:user.avatar]];
                [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
                
                [GlobalUtil addButtonToView:self sender:cell.img1 action:@selector(openMember:) data:user];
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
        }else
        {
            cell.txtName1.hidden = YES;
            cell.img1.hidden = YES;
            
            
            cell.txt11.hidden = YES;
            cell.txt12.hidden = YES;
            cell.txt21.hidden = YES;
            cell.txt22.hidden = YES;
            cell.txt31.hidden = YES;
            cell.txt32.hidden = YES;
            cell.txt41.hidden = YES;
            cell.txt42.hidden = YES;
            cell.txt51.hidden = YES;
            cell.txt52.hidden = YES;
            
            cell.lab1.hidden = YES;
            cell.lab2.hidden = YES;
            cell.lab3.hidden = YES;
            cell.lab4.hidden = YES;
            cell.lab5.hidden = YES;
            cell.lab6.hidden = YES;
            cell.lab7.hidden = YES;
            cell.lab8.hidden = YES;
            cell.lab9.hidden = YES;
            cell.lab10.hidden = YES;
            
            
        }

        
    }
    
    if ([[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:1]) {
        
        
        MatchDataUser *entity = (MatchDataUser*)[[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:1];
        
        if ((NSNull*)entity!=[NSNull null]) {
            NSDictionary *dict = entity.user;
            User *user= (User*)[MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dict error:nil];
            cell.txtName2.text = user.nickname;
            
            if(user.avatar)
            {
                NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:user.avatar]];
                [cell.img2 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
                
                [GlobalUtil addButtonToView:self sender:cell.img2 action:@selector(openMember:) data:user];
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

        
        }else
        {
            cell.txtName2.hidden = YES;
            cell.img2.hidden = YES;
            
            
            cell.txt13.hidden = YES;
            cell.txt14.hidden = YES;
            cell.txt23.hidden = YES;
            cell.txt24.hidden = YES;
            cell.txt33.hidden = YES;
            cell.txt34.hidden = YES;
            cell.txt43.hidden = YES;
            cell.txt44.hidden = YES;
            cell.txt53.hidden = YES;
            cell.txt54.hidden = YES;
            
            cell.lab11.hidden = YES;
            cell.lab12.hidden = YES;
            cell.lab13.hidden = YES;
            cell.lab14.hidden = YES;
            cell.lab15.hidden = YES;
            cell.lab16.hidden = YES;
            cell.lab17.hidden = YES;
            cell.lab18.hidden = YES;
            cell.lab19.hidden = YES;
            cell.lab20.hidden = YES;
            
        }
        
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
