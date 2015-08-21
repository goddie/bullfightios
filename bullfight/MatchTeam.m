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
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self globalConfig];
    
    self.tableView.backgroundColor = [GlobalConst appBgColor];
    
    [self addButton];
    [self addLeftNavButton];
    [self addRightNavButton];

 
 
    dataArr = @[
                @"1",@"2",@"0",@"1"
 
                ];
    tabIndex = 0;
    
    self.title = @"比赛";
    
    [self.topView addSubview:[self getTopView]];
    
    matchType = [NSNumber numberWithInt:1];
    status = [NSNumber numberWithInt:-1];
    dataArr2 = [NSMutableArray arrayWithCapacity:10];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self getData];
    
}


-(void)btnClick
{
    MatchCreate *matchCreate = [[MatchCreate alloc] initWithNibName:@"MatchCreate" bundle:nil];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:matchCreate];
    
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
    
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
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(0,0,26,30)];
    refreshButton.userInteractionEnabled = YES;
    [refreshButton setImage:[UIImage imageNamed:@"teamIcon.png"] forState:UIControlStateNormal];
    [GlobalUtil setMaskImageQuick:refreshButton withMask:@"shared_avatar_mask_medium.png" point:CGPointMake(26, 30)];
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.leftBarButtonItem = refreshBarButton;
    [refreshButton addTarget:self action:@selector(leftPush) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addRightNavButton
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(0,0,26,30)];
    refreshButton.userInteractionEnabled = YES;
    [refreshButton setImage:[UIImage imageNamed:@"nav_filter.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    [refreshButton addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
}



-(void)leftPush
{
    Notice *c1 = [[Notice alloc] initWithNibName:@"Notice" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
}

-(void)rightPush
{
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


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"%ld",buttonIndex);
    
    if (buttonIndex==0) {
        status = [NSNumber numberWithInt:-1];
    }
    
    if (buttonIndex==1) {
        status = [NSNumber numberWithInt:0];
    }
    
    if (buttonIndex==2) {
        status = [NSNumber numberWithInt:1];
    }
    
    if (buttonIndex==3) {
        status = [NSNumber numberWithInt:2];
    }
    
    [self getData];
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

/**
 *  比赛列表
 */
-(void)getData
{
    
//    NSLog(@"getData");
    NSDictionary *parameters = @{
                                 @"matchType":matchType,
                                 @"status":status
                                 };
    [dataArr2 removeAllObjects];
    
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
        
    }];

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
    
    
    MatchFight *entity = (MatchFight*)[dataArr2 objectAtIndex:indexPath.row];
    
    int t = [entity.status intValue];

    //未开始
    if (t==1) {
        static NSString *CellIdentifier = @"MatchBeginCell";
        MatchBeginCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        
        [GlobalUtil addButtonToView:self sender:cell.img1 action:@selector(openTeam1:) data:entity.host ];
        [GlobalUtil addButtonToView:self sender:cell.img2 action:@selector(openTeam1:) data:entity.guest ];
        
        
        NSString *a1 = [@"" stringByAppendingString:[entity.host objectForKey:@"avatar"]];
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a1]];
        [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
        
        NSString *a2 = [@"" stringByAppendingString:[entity.guest objectForKey:@"avatar"]];
        NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a2]];
        [cell.img2 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];

        
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
        static NSString *CellIdentifier = @"MatchHalfCell";
        MatchHalfCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        [GlobalUtil addButtonToView:self sender:cell.img1 action:@selector(openTeam1:) data:entity.host];
//        [GlobalUtil addButtonToView:self sender:cell.img2 action:@selector(openTeam1) data:[entity.guest objectForKey:@"id"]];
        //[GlobalUtil addButtonToView:self sender:cell.img2 action:@selector(openTeam1) data:10];
        
        
        NSString *a1 = [@"" stringByAppendingString:[entity.host objectForKey:@"avatar"]];
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a1]];
        [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
        
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
    static NSString *CellIdentifier = @"MatchFinishCell";
    MatchFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    [GlobalUtil addButtonToView:self sender:cell.img1 action:@selector(openTeam1:) data:entity.host];
    [GlobalUtil addButtonToView:self sender:cell.img2 action:@selector(openTeam1:) data:entity.guest];
    
    
    NSString *a1 = [@"" stringByAppendingString:[entity.host objectForKey:@"avatar"]];
    NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a1]];
    [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    
    NSString *a2 = [@"" stringByAppendingString:[entity.guest objectForKey:@"avatar"]];
    NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a2]];
    [cell.img2 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MatchFight *entity = (MatchFight*)[dataArr2 objectAtIndex:indexPath.row];
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


@end
