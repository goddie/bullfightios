//
//  MatchTeam.m
//  bullfight
//  比赛团队
//  Created by goddie on 15/8/4.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchTeam.h"
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

@interface MatchTeam ()

@end

@implementation MatchTeam
{
    NSArray *cellArr;
    NSInteger tabIndex;
    NSString *cellIdentifier;
    NSArray *dataArr;
    NSArray *cellHeightArr;
    
    NSMutableArray *dataArr2;
    
    NSNumber *page;
    NSString *city;
    NSNumber *matchType;
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
    
    [self addButton];
    [self addLeftNavButton];
    [self addRightNavButton];

 
    self.title = @"比赛";
    tabIndex = 0;
    
    cellArr = @[
                @[@"MatchBeginCell"]
                ,@[@"MatchWildCell"]
                ];
    
    [self.topView addSubview:[self getTopView]];
    noticeIcon.image = [UIImage imageNamed:@"holder.png"];
    
    matchType = [NSNumber numberWithInt:1];
    status = [NSNumber numberWithInt:-1];
    dataArr2 = [NSMutableArray arrayWithCapacity:10];
    
    
    curPage = [NSNumber numberWithInt:1];
    __weak MatchTeam *wkSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [wkSelf refresh];
        
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [wkSelf loadMore];
        
    }];
    
    [self loadData];
    

    
}




-(void)leftAvatar
{
//    if(self.uu)
//    {
//        NSString *a1 = [@"" stringByAppendingString:[entity.host objectForKey:@"avatar"]];
//        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a1]];
//        [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
//    }

    NSString *uuid = [LoginUtil getLocalUUID];
    if (!uuid) {
        [noticeIcon setImage:[UIImage imageNamed:@"holder.png"]];
        return;
    }

        
    NSDictionary *parameters = @{
                                 @"uid":uuid
                                 };

    [self post:@"user/json/getuser" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [dict objectForKey:@"data"];
            NSError *error = nil;
            user  = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
            
            if (user) {
                [self loadAvatar];
            }
            
        }
    }];
    
    
    //未读消息
    [self post:@"message/json/countnew" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSNumber *count = (NSNumber*)[dict objectForKey:@"data"];
            
//            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 10, 10)];
            
 
            
            
            if ([count intValue]>0) {
                
                [numButton setBackgroundImage:[UIImage imageNamed:@"redbg.png"] forState:UIControlStateNormal];
                //            [btn setTitle:@"99" forState:UIControlStateNormal];
                [numButton setTitle:[NSString stringWithFormat:@"%d",[count intValue]] forState:UIControlStateNormal];
                [numButton.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
                //            btn.titleLabel.tintColor = [UIColor whiteColor];
                
                
            }else
            {
                numButton.hidden=YES;
            }
            

        }
    }];
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [self leftAvatar];
}

-(void)loadAvatar
{
    if(user.avatar)
    {
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:user.avatar]];
        [noticeIcon sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];

    }else
    {
        [noticeIcon setImage:[UIImage imageNamed:@"holder.png"]];
    }
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
 
    NSDictionary *parameters = @{
                                 @"p":curPage,
                                 @"matchType":matchType,
                                 @"status":status
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
 *  创建比赛按钮
 */
-(void)addButton
{
   
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"fight_btn_add.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnParent addSubview:btn];
}

//SegmentedControl触发的动作

-(void)switchView:(id)sender{
    
    UISegmentedControl *control = (UISegmentedControl *)sender;
    tabIndex = control.selectedSegmentIndex;
    
    if (tabIndex==0) {
        matchType = [NSNumber numberWithInt:1];
    }
    if (tabIndex==1) {
        matchType = [NSNumber numberWithInt:2];
    }
    
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



-(void)addLeftNavButton
{
    refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(0,0,30,30)];
    refreshButton.userInteractionEnabled = YES;
//    leftTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"holder.png"]];
    noticeIcon = [[UIImageView alloc] initWithFrame:refreshButton.frame];
    [refreshButton addSubview:noticeIcon];
//    [refreshButton setBackgroundImage:[UIImage imageNamed:@"holder.png"] forState:UIControlStateNormal];
    [GlobalUtil setMaskImageQuick:noticeIcon withMask:@"shared_avatar_mask_medium.png" point:CGPointMake(26, 30)];
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.leftBarButtonItem = refreshBarButton;
    [refreshButton addTarget:self action:@selector(leftPush) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    numButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 14, 14)];
    [refreshButton addSubview:numButton];
}

-(void)addRightNavButton
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0,0,26,30)];
    rightBtn.userInteractionEnabled = YES;
    [rightBtn setImage:[UIImage imageNamed:@"nav_filter.png"] forState:UIControlStateNormal];
    
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
    
    if (tabIndex==0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"选择比赛"
                                      delegate:self
                                      cancelButtonTitle:@"关闭"
                                      destructiveButtonTitle:@"全部比赛"
                                      otherButtonTitles:@"待应战",@"未开始",@"已结束",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tag = 100;
        [actionSheet showInView:self.view];
    }
    
    if (tabIndex==1) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"选择比赛"
                                      delegate:self
                                      cancelButtonTitle:@"关闭"
                                      destructiveButtonTitle:@"全部比赛"
                                      otherButtonTitles:@"未结束",@"已结束",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tag = 200;
        [actionSheet showInView:self.view];
    }

}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
  
}

-(UIView*)getTopView
{
    float w = [[UIScreen mainScreen] bounds].size.width;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 50.0f)];
    parent.backgroundColor = [GlobalConst appBgColor];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"团队约战",@"野球娱乐"]];
    segmentedControl.layer.borderColor = [[GlobalConst tabTintColor] CGColor];
    segmentedControl.layer.borderWidth = 2.0f;
    
    
    segmentedControl.layer.masksToBounds = YES;
    segmentedControl.layer.cornerRadius = 15.0f;
    segmentedControl.frame = CGRectMake((w-200.0f)*0.5f, 10.0f, 200.0f, 30.0f);
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
    return 190.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [[cellArr objectAtIndex:([matchType intValue]-1)] objectAtIndex:0];
    
    MatchBeginCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (dataArr2.count==0) {
        return cell;
    }
    
     MatchFight *entity = (MatchFight*)[dataArr2 objectAtIndex:indexPath.row];
    int t = [entity.status intValue];
    
    
    //团队约战
    if ([matchType intValue]==1) {
    
        
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
                NSString *a1 = [@"" stringByAppendingString:[entity.host objectForKey:@"avatar"]];
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
    
    //野球娱乐
    if ([matchType intValue]==2)
    {
        
        CellIdentifier = @"MatchWildCell";
        MatchWildCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }

        [cell setCorner:t];
        
        
        cell.txtDate.text = [GlobalUtil getDateFromUNIX:entity.start format:@"MM月dd日 HH:mm"];
        cell.txtPlace.text = [entity.arena objectForKey:@"name"];
        cell.txtWeather.text = entity.weather;
        
        
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
        MatchWild *c1 = [[MatchWild alloc] initWithNibName:@"MatchWild" bundle:nil];
        c1.matchFight = entity;
        c1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:c1 animated:YES];
    }
    
    
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


@end
