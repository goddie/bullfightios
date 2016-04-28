//
//  MatchTeam.m
//  bullfight
//  比赛团队
//  Created by goddie on 15/8/4.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchLeague.h"
#import "MatchBeginCell.h"
#import "MFController.h"
#import "MatchCreate.h"
#import "TIController.h"
#import "MatchFinishCell.h"
#import "MatchHalfCell.h"
#import "Notice.h"
#import "UIViewController+Custome.h"
#import "MatchFight.h"
#import "UIImageView+WebCache.h"
#import "MyButton.h"
#import "MFWildController.h"
#import "MEController.h"
#import "AppDelegate.h"
#import "MatchWild.h"
#import "MatchWildCell.h"
#import "MatchLeagueCell.h"
#import "MatchLeagueRecordCell.h"
#import "MatchLeagueHeadCell.h"
#import "League.h"
#import "LeagueRecord.h"
#import "LeagueJoin.h"
#import "DataUser.h"
#import "LeagueDataCell.h"
#import "LeagueHeadCell.h"


@interface MatchLeague ()

@end

@implementation MatchLeague
{
    NSArray *cellArr;
    NSInteger tabIndex;
    NSString *cellIdentifier;
    NSArray *dataArr;
    NSArray *cellHeightArr;
    
    NSMutableArray *dataArr2;
    
    NSNumber *page;
    NSString *city;

    NSNumber *status;
    
    NSNumber *curPage;
    
    User *user;
    
    UIImageView  *noticeIcon;
    
    UIButton *refreshButton;
    UIButton *numButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self globalConfig];
    
    self.tableView.backgroundColor = [GlobalConst appBgColor];
    
 

    [self addRightNavButton];

 
    self.title = @"联赛竞技";
    tabIndex = 0;
    
    cellArr = @[
                @[@"MatchBeginCell"]
                ,@[@"MatchWildCell"]
                ,@[@"LeagueDataCell"]
                ,@[@"LeagueDataCell"]
                ,@[@"LeagueDataCell"]
                ];
    
    [self.topView addSubview:[self getTopView]];
    noticeIcon.image = [UIImage imageNamed:@"holder.png"];
    

    status = [NSNumber numberWithInt:-1];
    dataArr2 = [NSMutableArray arrayWithCapacity:10];
    
    
    curPage = [NSNumber numberWithInt:1];
    __weak MatchLeague *wkSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [wkSelf refresh];
        
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [wkSelf loadMore];
        
    }];
    
    [self loadData];
    

    
}



-(void)refresh
{
    [dataArr2 removeAllObjects];
    status = [NSNumber numberWithInt:-1];
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

/**
 *  比赛列表
 */
-(void)loadData
{
    
    [self showHud];
 

    
    //对阵
    if (tabIndex==0) {
        
        if(!self.leagueid)
        {
            return;
        }
        
        NSDictionary *parameters = @{
                                     @"p":curPage,
                                     @"matchType":@"3",
                                     @"status":status,
                                     @"leagueid":self.leagueid
                                     };
        
        [self post:@"matchfight/json/matchlist" params:parameters success:^(id responseObj) {
            
            NSDictionary *dict = (NSDictionary *)responseObj;
            
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arr = [dict objectForKey:@"data"];
                NSError *error = nil;
                
                for (NSDictionary *data in arr) {
                    MatchFight *model = [MTLJSONAdapter modelOfClass:[MatchFight class] fromJSONDictionary:data error:&error];
                    //                NSLog(@"%@",[error description]);
                    if (model!=nil) {
                        [dataArr2 addObject:model];
                    }
                }
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            
            [self.tableView reloadData];
            [self stopAnimation];
        }];

    }
    
    
    /**
     *  积分
     */
    if (tabIndex == 1) {
        
        NSDictionary *parameters = @{
                                     @"p":curPage,
                                     @"leagueid":self.leagueid
                                     };
        
        [self post:@"leaguerecord/json/list" params:parameters success:^(id responseObj) {
            
            NSDictionary *dict = (NSDictionary *)responseObj;
            
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arr = [dict objectForKey:@"data"];
                NSError *error = nil;
                
                for (NSDictionary *data in arr) {
                    LeagueRecord *model = [MTLJSONAdapter modelOfClass:[LeagueRecord class] fromJSONDictionary:data error:&error];
                    //                NSLog(@"%@",[error description]);
                    if (model!=nil) {
                        [dataArr2 addObject:model];
                    }
                }
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            
            [self.tableView reloadData];
            [self stopAnimation];
        }];
        
    }

    
    
    if (tabIndex == 2||tabIndex == 3||tabIndex == 4) {
        
        NSDictionary *parameters = @{
                                     @"p":curPage,
                                     @"leagueid":self.leagueid
                                     };
        
        NSString *url;
        
        if(tabIndex == 2)
        {
            url = @"matchdatauser/json/leaguepoint";
        }
        
        if(tabIndex == 3)
        {
            url = @"matchdatauser/json/leaguerebound";
        }
        
        if(tabIndex == 4)
        {
            url = @"matchdatauser/json/leagueassist";
        }
        
        [self post:url params:parameters success:^(id responseObj) {
            
            NSDictionary *dict = (NSDictionary *)responseObj;
            
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arr = [dict objectForKey:@"data"];
                NSError *error = nil;
                
                for (NSDictionary *data in arr) {
                    DataUser *model = [MTLJSONAdapter modelOfClass:[DataUser class] fromJSONDictionary:data error:&error];
                    //                NSLog(@"%@",[error description]);
                    if (model!=nil) {
                        [dataArr2 addObject:model];
                    }
                }
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            
            [self.tableView reloadData];
            [self stopAnimation];
        }];
        
    }
    
    
}





//SegmentedControl触发的动作

-(void)switchView:(id)sender{
    
    UISegmentedControl *control = (UISegmentedControl *)sender;
    tabIndex = control.selectedSegmentIndex;
    
    [dataArr2 removeAllObjects];
    curPage = [NSNumber numberWithInt:1];
    [self loadData];
    
}

/**
 *  创建比赛
 */
-(void)btnClick
{
    
    [[AppDelegate delegate] loginPage];
    
    MatchCreate *matchCreate = [[MatchCreate alloc] initWithNibName:@"MatchCreate" bundle:nil];
    matchCreate.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:matchCreate animated:YES];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:matchCreate];
//    
//    
//    [self presentViewController:nav animated:YES completion:^{
//        
//    }];
    
    
}



-(void)setTab
{
    
}


-(void)openTeam1:(id)sender;
{
    TIController *c1 = [[TIController alloc] initWithNibName:@"TIController" bundle:nil];
    MyButton *btn = (MyButton*)sender;
    NSDictionary* dict =(NSDictionary*)btn.data;
    Team *t = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:dict error:nil];
    c1.team = t;
    c1.uuid = t.uuid;
    [self.navigationController pushViewController:c1 animated:YES];
}




-(void)addRightNavButton
{
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0,0,40,30)];
    rightBtn.userInteractionEnabled = YES;
    [rightBtn setTitle:@"加入" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    //[rightBtn setImage:[UIImage imageNamed:@"nav_filter.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    [rightBtn addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
}



-(void)leftPush
{
    
    [[AppDelegate delegate] loginPage];
    
    
    Notice *c1 = [[Notice alloc] initWithNibName:@"Notice" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
}

-(void)rightPush
{
    LeagueJoin *leagueJoin =  [[LeagueJoin alloc] initWithNibName:@"LeagueJoin" bundle:nil];
    leagueJoin.league = self.league;
    
    [self.navigationController pushViewController:leagueJoin animated:YES];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    NSLog(@"%ld",buttonIndex);
    
    if (actionSheet.tag==100) {
        if (buttonIndex==0) {
            status = [NSNumber numberWithInteger:-1];
        }
        
        if (buttonIndex==1) {
            status = [NSNumber numberWithInteger:0];
        }
        
        if (buttonIndex==2) {
            status = [NSNumber numberWithInteger:1];
        }
        
        if (buttonIndex==3) {
            status = [NSNumber numberWithInteger:2];
        }
        
        [dataArr2 removeAllObjects];
        
        curPage = [NSNumber numberWithInt:1];
        
        [self loadData];
    }
    
    
    if (actionSheet.tag==200) {
        if (buttonIndex==0) {
            status = [NSNumber numberWithInteger:-1];
        }
        
        if (buttonIndex==1) {
            status = [NSNumber numberWithInteger:1];
        }
        
        if (buttonIndex==2) {
            status = [NSNumber numberWithInteger:2];
        }
        
        
        [dataArr2 removeAllObjects];
        
        curPage = [NSNumber numberWithInt:1];
        
        [self loadData];
    }
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
 
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
  
}

-(UIView*)getTopView
{
    float w = [[UIScreen mainScreen] bounds].size.width;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 50.0f)];
    parent.backgroundColor = [GlobalConst appBgColor];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"对阵",@"积分",@"得分",@"篮板",@"助攻"]];
    segmentedControl.layer.borderColor = [[GlobalConst tabTintColor] CGColor];
    segmentedControl.layer.borderWidth = 2.0f;
    
    
    segmentedControl.layer.masksToBounds = YES;
    segmentedControl.layer.cornerRadius = 15.0f;
    segmentedControl.frame = CGRectMake((w-280.0f)*0.5f, 10.0f, 280.0f, 30.0f);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [GlobalConst tabTintColor];
    
    //segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    
    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"shared_segmented_control_selected.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    //    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"shared_segmented_control_selected.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],UITextAttributeTextColor,  [UIFont systemFontOfSize:15],UITextAttributeFont ,[UIColor clearColor],UITextAttributeTextShadowColor ,nil];
    //    [ self.Segmented setTitleTextAttributes:dic forState:UIControlStateSelected];
    //
    //    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,  [UIFont systemFontOfSize:15],UITextAttributeFont ,[UIColor clearColor],UITextAttributeTextShadowColor ,nil];
    
    
    [segmentedControl addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    
    
    [parent addSubview:segmentedControl];
    
    return  parent;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArr2.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tabIndex==1)
    {
        return 80.0f;
    }
    if(tabIndex==2||tabIndex==3||tabIndex==4)
    {
        return 80.0f;
    }
    return 190.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:0];
    
    MatchBeginCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (dataArr2.count==0) {
        return cell;
    }
    
    
    

    
    
    //对战
    if (tabIndex==0) {
        
        MatchFight *entity = (MatchFight*)[dataArr2 objectAtIndex:indexPath.row];
        int t = [entity.status intValue];
    
        
        //未开始
        if (t==1) {
            CellIdentifier = @"MatchBeginCell";
            MatchBeginCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell==nil){
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            
            
            [GlobalUtil addButtonToView:self sender:cell.img1 action:@selector(openTeam1:) data:entity.host ];
            [GlobalUtil addButtonToView:self sender:cell.img2 action:@selector(openTeam1:) data:entity.guest ];
            
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
            
            
            
            cell.txtTeam1.text = [entity.host objectForKey:@"name"];
            cell.txtTeam2.text = [entity.guest objectForKey:@"name"];
            cell.txtPlace.text = [entity.arena objectForKey:@"name"];
            cell.txtNum1.text = [GlobalUtil toString:entity.teamSize];
            cell.txtNum2.text = [GlobalUtil toString:entity.teamSize];
            cell.txtWeather.text = entity.weather;
            cell.txtDate.text = [GlobalUtil getDateFromUNIX:entity.start];
            
            
            return  cell;
        }
        
        //未接招
        if (t==0) {
            CellIdentifier = @"MatchHalfCell";
            MatchHalfCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell==nil){
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            
            [GlobalUtil addButtonToView:self sender:cell.img1 action:@selector(openTeam1:) data:entity.host];
            //        [GlobalUtil addButtonToView:self sender:cell.img2 action:@selector(openTeam1) data:[entity.guest objectForKey:@"id"]];
            //[GlobalUtil addButtonToView:self sender:cell.img2 action:@selector(openTeam1) data:10];
            
            if([entity.host objectForKey:@"avatar"])
            {
                NSString *a1 = [GlobalUtil toString:[entity.host objectForKey:@"avatar"]];
                NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a1]];
                [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
            }
            
            
            //        NSString *a2 = [@"" stringByAppendingString:[entity.host objectForKey:@"avatar"]];
            //        NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a2]];
            //        [cell.img2 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
            
            
            cell.txtTeam1.text = [entity.host objectForKey:@"name"];
            cell.txtTeam2.text = [entity.guest objectForKey:@"name"];
            cell.txtPlace.text = [entity.arena objectForKey:@"name"];
            cell.txtNum1.text = [GlobalUtil toString:entity.teamSize];
            cell.txtNum2.text = [GlobalUtil toString:entity.teamSize];
            cell.txtWeather.text = entity.weather;
            cell.txtDate.text = [GlobalUtil getDateFromUNIX:entity.start];
            
            
            return  cell;
        }
        
        //已结束 2
        if (t==2) {
            CellIdentifier = @"MatchFinishCell";
            MatchFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell==nil){
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            
            [GlobalUtil addButtonToView:self sender:cell.img1 action:@selector(openTeam1:) data:entity.host];
            [GlobalUtil addButtonToView:self sender:cell.img2 action:@selector(openTeam1:) data:entity.guest];
            
            
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
            
            
            
            cell.txtTeam1.text = [entity.host objectForKey:@"name"];
            cell.txtTeam2.text = [entity.guest objectForKey:@"name"];
            cell.txtPlace.text = [entity.arena objectForKey:@"name"];
            cell.txtNum1.text = [GlobalUtil toString:entity.teamSize];
            cell.txtNum2.text = [GlobalUtil toString:entity.teamSize];
            //    cell.txtWeather.text = entity.weather;
            cell.txtDate.text = [GlobalUtil getDateFromUNIX:entity.start];
            cell.txtScore.text = [NSString stringWithFormat:@"%@:%@", [GlobalUtil toString:entity.hostScore],[GlobalUtil toString:entity.guestScore]];
            
            return  cell;
        }

        
    }
    

    
    
    //积分
   if (tabIndex==1)
    {
        
        LeagueRecord *entity = (LeagueRecord*)[dataArr2 objectAtIndex:indexPath.row];
        
        
        
        CellIdentifier = @"MatchLeagueRecordCell";
        MatchLeagueRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (indexPath.row % 2 == 0) {
            
            cell.backgroundColor = [GlobalConst lightAppBgColor];
        }else
        {
            cell.backgroundColor = [UIColor clearColor];
        }

        
        Team *team = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:entity.team error:nil];
        
        if(team.avatar)
        {
            NSString *a2 = [@"" stringByAppendingString:team.avatar];
            NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a2]];
            [cell.img1 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
        }
        
        cell.team.text = team.name;
        cell.txt1.text = [GlobalUtil toString:entity.win];
        cell.txt2.text = [GlobalUtil toString:entity.lose];
        cell.txt3.text = [GlobalUtil toString:entity.score];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return  cell;
        
        
        
    }
    
    //得分 篮板 助攻
    if (tabIndex==2||tabIndex==3||tabIndex==4)
    {
        DataUser *entity = (DataUser*)[dataArr2 objectAtIndex:indexPath.row];
        
        
        
        CellIdentifier = @"LeagueDataCell";
        LeagueDataCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (indexPath.row % 2 == 0) {
            
            cell.backgroundColor = [GlobalConst lightAppBgColor];
        }else
        {
            cell.backgroundColor = [UIColor clearColor];
        }
        
        
        User *u = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:entity.user error:nil];
        
        if(u.avatar)
        {
            NSString *a2 = [@"" stringByAppendingString:u.avatar];
            NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a2]];
            [cell.img1 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
        }
        
        cell.txt1.text = u.nickname;
        
        
        if(tabIndex==2)
        {
            cell.txt2.text = [GlobalUtil decimalwithFormat:@"0.0" floatV:[entity.plays floatValue]];
            cell.txt3.text = [GlobalUtil decimalwithFormat:@"0.0" floatV:[entity.scoring floatValue]];
            cell.txt4.text = [GlobalUtil decimalwithFormat:@"0.0" floatV:[entity.avgscoring floatValue]];
        }
        

        if(tabIndex==3)
        {
            
            cell.txt2.text = [GlobalUtil decimalwithFormat:@"0.0" floatV:[entity.plays floatValue]];
            cell.txt3.text = [GlobalUtil decimalwithFormat:@"0.0" floatV:[entity.rebound floatValue]];
            cell.txt4.text = [GlobalUtil decimalwithFormat:@"0.0" floatV:[entity.avgrebound floatValue]];
            
        }
        
        if(tabIndex==4)
        {
            
            cell.txt2.text = [GlobalUtil decimalwithFormat:@"0.0" floatV:[entity.plays floatValue]];
            cell.txt3.text = [GlobalUtil decimalwithFormat:@"0.0" floatV:[entity.assist floatValue]];
            cell.txt4.text = [GlobalUtil decimalwithFormat:@"0.0" floatV:[entity.avgassist floatValue]];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return  cell;

    }

 

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataArr2.count==0) {
        return;
    }
    
    MatchFight *entity = (MatchFight*)[dataArr2 objectAtIndex:indexPath.row];
    
    if (tabIndex==0) {
        
        //    UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        //    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        if([entity.status intValue]==0)
        {
            MFWildController *c1= [[MFWildController alloc] initWithNibName:@"MFWildController" bundle:nil];
            c1.matchFight = entity;
            c1.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:c1 animated:YES];
            
        }
        
        if([entity.status intValue]==1)
        {
            MFController *c1= [[MFController alloc] initWithNibName:@"MFController" bundle:nil];
            c1.matchFight = entity;
            c1.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:c1 animated:YES];
        }
        
        
        if([entity.status intValue]==2)
        {
            MEController *c1 = [[MEController alloc] initWithNibName:@"MEController" bundle:nil];
            c1.matchFight = entity;
            c1.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:c1 animated:YES];
            
        }

    }
    
    
    if (tabIndex==1) {
        
        return;
    }
    
    
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tabIndex==1) {
        return 44;
    }
    if (tabIndex==2||tabIndex==3||tabIndex==4) {
        return 44;
    }
    
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    if (tabIndex==1) {
        
        NSString *CellIdentifier = @"MatchLeagueHeadCell";
        MatchLeagueHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        //cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    if (tabIndex==2||tabIndex==3||tabIndex==4) {
        
        NSString *CellIdentifier = @"LeagueHeadCell";
        LeagueHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        //cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    return nil;
}


@end
