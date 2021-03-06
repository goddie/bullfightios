//
//  MFController.m
//  bullfight
//  未接招
//  Created by goddie on 15/8/8.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MFWildController.h"
#import "MFWildTop.h"
#import "MFMatchInfoCell.h"
#import "MyDataCell.h"
#import "MFMemberCell.h"
#import "MFMessageCell.h"
#import "TIController.h"
#import "MIController.h"
#import "MyButton.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "MTLJSONAdapter.h"
#import "MFTeamInfoTopCell.h"
#import "MFTeamInfoCell.h"
#import "AddMessage.h"
#import "Commet.h"
#import "MFMatchInfoBigCell.h"


@interface MFWildController ()

@end

@implementation MFWildController
{
    NSNumber *curPage;
    UIButton *commetBtn;
        User *reply;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.hidesBottomBarWhenPushed = YES;
    
    
    
    
    //    dataArr = @[@[@"东单体育中心18号场地",@"12月28日 14:00-15:30",@"晴转多云",@"裁判员一名，数据员两名",@"接受系统赛前通知提醒"],
    //                @[@"场均得分",@"场均篮板",@"场均助攻",@"场均失误",@"场均盖帽"],
    //                @[@"后卫",@"中锋",@"前锋"],
    //                @[@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了",@"打的很好，我也参加了"]];
    
    self.tableView.backgroundColor  = [GlobalConst lightAppBgColor];
    
    self.title = @"比赛信息";
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self addRightNavButton];
    curPage = [NSNumber numberWithInt:1];
    __weak MFWildController *wkSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [wkSelf refresh];
        
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [wkSelf loadMore];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refresh];
}

-(void)showReply
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"关闭"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"回复", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        AddMessage *c1 = [[AddMessage alloc] initWithNibName:@"AddMessage" bundle:nil];
        c1.mfid = self.matchFight.uuid;
        c1.reply = reply;
        [self.navigationController pushViewController:c1 animated:YES];
    }
}



-(void)addRightNavButton
{
    commetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commetBtn setFrame:CGRectMake(0,0,40,30)];
    
    [commetBtn setTitle:@"写评论" forState:UIControlStateNormal];
    [commetBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    commetBtn.userInteractionEnabled = YES;
    //    [commetBtn setImage:[UIImage imageNamed:@"activities_icon_comment@3x.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:commetBtn];
    
    self.navigationItem.rightBarButtonItem = barBtn;
    [commetBtn addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
    
    //    commetBtn.backgroundColor = [UIColor whiteColor];
    commetBtn.hidden = YES;
}

-(void)rightPush
{
    AddMessage *c1 = [[AddMessage alloc] initWithNibName:@"AddMessage" bundle:nil];
    c1.mfid = self.matchFight.uuid;
    [self.navigationController pushViewController:c1 animated:YES];
}

-(void)changeTab:(NSInteger)idx
{
    
    [super changeTab:idx];
    
    if (tabIndex==3) {
        commetBtn.hidden = NO;
    }else
    {   commetBtn.hidden = YES;
    }
}

-(void)refresh
{
    [dataArr4 removeAllObjects];
    curPage = [NSNumber numberWithInt:1];
    [self getData];
}

-(void)loadMore
{
    curPage = [NSNumber numberWithInt: [curPage intValue] + 1];
    
    [self getData];
}

-(void)stopAnimation
{
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView.infiniteScrollingView stopAnimating];
    [self hideHud];
}



-(void)initData
{
    cellHeightArr = @[
                      @[@50,@50,@50,@50,@50,@100],
                      @[@80],
                      @[@160],
                      @[@160]
                      ];
    topHeight = 240;
    cellArr = @[
                @[@"MFMatchInfoCell",@"MFMatchInfoBigCell"],
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
    
    MFWildTop *top = [[MFWildTop alloc] initWithNibName:@"MFWildTop" bundle:nil];
    [self addChildViewController:top];
    top.matchFight = self.matchFight;
    top.topDelegate = self;
    
    
    sectionHeader = top.view;
    
    return sectionHeader;
}



//-(void)changeTab:(NSInteger)idx
//{
//    if(tabIndex==idx)
//    {
//        return;
//    }
//    
//    tabIndex = idx;
//    
//    [self getData];
//}

-(void)getData
{
    //比赛信息
    if (tabIndex==0) {
        
        if([dataArr1 count])
        {
            [self.tableView reloadData];
            [self stopAnimation];
            return;
        }
        
        
        NSString *s1 = [NSString stringWithFormat:@"裁判员%@名，数据员%@名",
                        [GlobalUtil toString:self.matchFight.judge],
                        [GlobalUtil toString:self.matchFight.dataRecord]];
        
        NSString *arena = [NSString stringWithFormat:@"%@\r\n%@" ,[self.matchFight.arena objectForKey:@"name"], [self.matchFight.arena objectForKey:@"address"]];
        
        [dataArr1 addObject:@[@"shared_icon_location.png",arena]];
        
        [dataArr1 addObject:@[@"shared_icon_time.png",[GlobalUtil toString:[GlobalUtil getDateFromUNIX:self.matchFight.start format:@"yyyy-MM-dd HH:mm"]]]];
    
        if([[GlobalUtil toString:self.matchFight.weather] length]>0)
        {
            [dataArr1 addObject:@[@"shared_icon_weather.png",[GlobalUtil toString:self.matchFight.weather]]];
        }
        
        if([self.matchFight.judge integerValue]>0||[self.matchFight.dataRecord integerValue]>0)
        {
            [dataArr1 addObject:@[@"shared_icon_jurge.png",s1]];
        }
        
        
        
        if([self.matchFight.fee integerValue]>0)
        {
            [dataArr1 addObject:@[@"shared_icon_money.png",[GlobalUtil toString:self.matchFight.fee]]];
        }
        
        if (self.matchFight.content.length>0) {
            [dataArr1 addObject:@[@"activities_icon_comment_active.png",[GlobalUtil toString:self.matchFight.content]]];
        }
       
        
        
        [self.tableView reloadData];
        
    }
    
    
    //球队数据
    if (tabIndex==1) {
        
        
        if([dataArr2 count])
        {
            [self.tableView reloadData];
            [self stopAnimation];
            return;
        }
        
        NSDictionary *hdict = self.matchFight.host;
        Team *host = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:hdict error:nil];
        
//        NSDictionary *hdict2 = self.matchFight.host;
//        Team *guest = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:hdict2 error:nil];
        
        
        
        
        [dataArr2 addObject:@[@"历史战绩",[GlobalUtil toString:host.playCount],[GlobalUtil toString:host.win]]];
        [dataArr2 addObject:@[@"场均得分",[GlobalUtil toFloatString:host.scoring]]];
        [dataArr2 addObject:@[@"场均篮板",[GlobalUtil toFloatString:host.rebound]]];
        [dataArr2 addObject:@[@"场均助攻",[GlobalUtil toFloatString:host.assist]]];
        [dataArr2 addObject:@[@"场均失误",[GlobalUtil toFloatString:host.turnover]]];
        [dataArr2 addObject:@[@"场均盖帽",[GlobalUtil toFloatString:host.block]]];
        
        
        
        [self.tableView reloadData];
        

        
//        if([dataArr2 count])
//        {
//            [self.tableView reloadData];
//            return;
//        }
//        
//        
//        NSDictionary *data = self.matchFight.host;
//        Team *team = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:data error:nil];
//        
//        [dataArr2 addObject:@[@[@"投篮命中率",[GlobalUtil toString:team.goalPercent]],@[@"罚球命中率",[GlobalUtil toString:team.freeGoalPercent]]]];
//        [dataArr2 addObject:@[@[@"三分球命中率",[GlobalUtil toString:team.threeGoalPercent]],@[@"场均犯规",[GlobalUtil toString:team.goalPercent]]]];
//        [dataArr2 addObject:@[@[@"场均篮板",[GlobalUtil toString:team.goalPercent]],@[@"场均助攻",[GlobalUtil toString:team.goalPercent]]]];
//        [dataArr2 addObject:@[@[@"场均失误",[GlobalUtil toString:team.goalPercent]],@[@"场均抢断",[GlobalUtil toString:team.goalPercent]]]];
// 
//        [self.tableView reloadData];
    }
    
    //个人数据
    if (tabIndex==2) {
        
        NSString *hostid = [self.matchFight.host objectForKey:@"id"];
        
        NSDictionary *parameters = @{
                                     @"hostid":hostid,
                                     @"guestid":@"",
                                     @"p":@"1"
                                     };
        [dataArr3 removeAllObjects];
        [self showHud];
        [self post:@"teamuser/json/memberlistboth" params:parameters success:^(id responseObj) {
            NSDictionary *dict = (NSDictionary *)responseObj;
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arrBig = [dict objectForKey:@"data"];
                NSError *error = nil;
                
                NSArray *arr1 =[arrBig objectAtIndex:0];

                for (NSDictionary *data in arr1) {
                    User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
                    if (model!=nil) {
                        [dataArr3 addObject:model];
                    }
                }
            }
            [self.tableView reloadData];
            [self stopAnimation];
        }];



        
        
    }
    
    //赛前动员
    if (tabIndex==3) {
        NSDictionary *parameters = @{
                                     @"mfid":self.matchFight.uuid,
                                     @"p":curPage
                                     };
        [self showHud];
        
        
        
        [self post:@"commet/json/list" params:parameters success:^(id responseObj) {
            NSDictionary *dict = (NSDictionary *)responseObj;
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arr = [dict objectForKey:@"data"];
                
                if (arr.count>0) {
                    [dataArr4 removeAllObjects];
                }
                NSError *error = nil;
                for (NSDictionary *data in arr) {
                    Commet *model = [MTLJSONAdapter modelOfClass:[Commet class] fromJSONDictionary:data error:&error];
                    if (model!=nil) {
                        [dataArr4 addObject:model];
                    }
                }
                
                
                [self.tableView reloadData];
                
 
            }
            
            [self stopAnimation];
            
        }];
    }
    
    
}



-(void)openMember:(id)sender
{
    MyButton *btn = (MyButton*)sender;
    
    MIController *c1 = [[MIController alloc] initWithNibName:@"MIController" bundle:nil];
    c1.user = (User*)btn.data;
    [self.navigationController pushViewController:c1 animated:YES];
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (tabIndex == 0  || tabIndex==3) {
        return UITableViewAutomaticDimension;
    }
    
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
    
    /**
     *  球队数据
     */
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
            
            [cell.txtFight2 setHidden:YES];
            [cell.txtWin2 setHidden:YES];
            [cell.txta setHidden:YES];
            [cell.txtb setHidden:YES];
            //cell.txtFight2.text = [[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:3];
            //cell.txtWin2.text = [[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:4];
            return cell;
        }
        
        
        MFTeamInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        cell.txtName.text = [[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.txt1.text =[[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:1];
        cell.txt2.text = @"";

        
//        MyDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (cell == nil) {
//            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
//            cell = [nibArray objectAtIndex:0];
//        }
//        
//        cell.lab1.text = [[[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:0] objectAtIndex:0];
//        cell.txt1.text = [[[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:0] objectAtIndex:1];
//        
//        cell.lab2.text = [[[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:1] objectAtIndex:0];
//        cell.txt2.text = [[[dataArr2 objectAtIndex:indexPath.row] objectAtIndex:1] objectAtIndex:1];
//        
//        
//        return cell;
        
        return cell;
        
    }
    
    
    /**
     *  个人数据
     */
    if (tabIndex==2) {
        
        MFMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        if (dataArr3.count==0) {
            return cell;
        }
        
        if ([dataArr3 objectAtIndex:indexPath.row]) {
            
            
            User *user= (User*)[dataArr3 objectAtIndex:indexPath.row];
            
            cell.txtName1.text = user.nickname;
            
            if(user.avatar)
            {
                NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:user.avatar]];
                [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
            }
            
            [GlobalUtil addButtonToView:self sender:cell.img1 action:@selector(openMember:) data:user];
        }
        
        
        //cell.txtPos.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        [cell.txtName2 setHidden:YES];
        [cell.img2 setHidden:YES];
        
        
        return cell;
    }
    
    
    if (tabIndex==3) {
        
        MFMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        
        Commet *commet = (Commet*)[dataArr4 objectAtIndex:indexPath.row];
        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:commet.from error:nil];
        //cell.img1.image = [UIImage imageNamed:[[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:0]];
        if(user.avatar)
        {
            NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:user.avatar]];
            [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
        }
        
        cell.txtName.text = user.nickname;
        cell.txtTime.text = [GlobalUtil getDateFromUNIX:commet.createdDate format:@"yyyy-MM-dd"];
        
        if (commet.reply) {
            
            User *reuser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:commet.reply error:nil];
            cell.txtContent.text = [NSString stringWithFormat:@"回复 %@ : %@",reuser.nickname,commet.content];
        }else
        {
            cell.txtContent.text = commet.content;
        }
        
//        cell.txtContent.text = commet.content;
        //        cell.backgroundColor = [UIColor redColor];
        //        cell.txtContent.backgroundColor = [UIColor yellowColor];
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
    if (tabIndex==2) {
        User *user = [dataArr3 objectAtIndex:indexPath.row];
        
        MIController *c1 = [[MIController alloc] initWithNibName:@"MIController" bundle:nil];
        
        c1.user = user;
        
        [self.navigationController pushViewController:c1 animated:YES];
    }
    
    
    if (tabIndex==3) {
        Commet *commet = (Commet*)[dataArr4 objectAtIndex:indexPath.row];
        reply = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:commet.from error:nil];
        [self showReply];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (tabIndex==3)
//    {
//        return 44.0f;
//    }
//    
//    
//    if (tabIndex==3) {
//        return UITableViewAutomaticDimension;
//    }
//    
//    int h  =[[[cellHeightArr objectAtIndex:tabIndex] objectAtIndex:0] intValue];
//    return h;

    
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
