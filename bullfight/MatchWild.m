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
#import "MFMessageCell.h"
#import "AddMessage.h"


#import "Commet.h"

@interface MatchWild ()

@end

@implementation MatchWild
{
    UIView *footerView;
    UIButton *commetBtn;
    NSNumber *curPage;
    User *reply;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    self.tableView.backgroundColor = [GlobalConst lightAppBgColor];
    
//    self.tableView.tableFooterView = [self getFooter];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"野球娱乐场";
    
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self addRightNavButton];
    
    curPage = [NSNumber numberWithInt:1];
    __weak MatchWild *wkSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [wkSelf refresh];
        
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [wkSelf loadMore];
        
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if (tabIndex==1) {
        commetBtn.hidden = NO;
    }else
    {   commetBtn.hidden = YES;
    }
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
    
    sectionHeader = top.view;
    
    return sectionHeader;
}



-(void)refresh
{
    [dataArr2 removeAllObjects];
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


-(void)getData
{
    //比赛信息
    if (tabIndex==0) {
        
        if([dataArr1 count])
        {
            [self.tableView reloadData];
            return;
        }

        NSString *arena = [NSString stringWithFormat:@"%@\r\n%@" ,[self.matchFight.arena objectForKey:@"name"], [self.matchFight.arena objectForKey:@"address"]];
        
        [dataArr1 addObject:@[@"shared_icon_location.png",arena]];
        
        
 
        [dataArr1 addObject:@[@"shared_icon_time.png",[GlobalUtil toString:[GlobalUtil getDateFromUNIX:self.matchFight.start format:@"yyyy-MM-dd HH:mm"]]]];
        
        
        NSString *w = [GlobalUtil toString:self.matchFight.weather];
        if (w.length>0) {
            [dataArr1 addObject:@[@"shared_icon_weather.png",[GlobalUtil toString:self.matchFight.weather]]];
        }
        
        if (self.matchFight.content.length>0) {
            [dataArr1 addObject:@[@"activities_icon_comment_active.png",[GlobalUtil toString:self.matchFight.content]]];
        }
        
        
        [self.tableView reloadData];
    }
    
    
    //评论
    if (tabIndex==1) {
        
        
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
                    [dataArr2 removeAllObjects];
                }
                
                NSError *error = nil;
                for (NSDictionary *data in arr) {
                    Commet *model = [MTLJSONAdapter modelOfClass:[Commet class] fromJSONDictionary:data error:&error];
                    if (model!=nil) {
                        [dataArr2 addObject:model];
                    }
                }
                
                [self.tableView reloadData];
                [self stopAnimation];
            }
            
        }];
    }
    
}


-(UIView*)getFooter
{
    if (footerView!=nil) {
        return footerView;
    }
    
    
    float w = [UIScreen mainScreen].bounds.size.width;
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 44.0f)];
    
    UIButton *btnSend  = [[UIButton alloc] initWithFrame:CGRectMake(w - 83.0f, 0, 83.0f, 44.0f)];
    [btnSend setTitle:@"发布" forState:UIControlStateNormal];
    [btnSend.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btnSend.titleLabel setTextColor:[UIColor whiteColor]];
    [btnSend setBackgroundImage:[UIImage imageNamed:@"comment_btn_send.png"] forState:UIControlStateNormal];
    [footerView addSubview:btnSend];
    
    UITextField *txt = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, w-90, 44.0f)];
    [txt setBorderStyle:UITextBorderStyleNone];
    
    [footerView addSubview:txt];
    
    footerView.backgroundColor = [GlobalConst appBgColor];
    
    return footerView;
}


-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    attrs[NSFontAttributeName]=font;
    
    CGSize maxSize=CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int h = 0;
    
 
    
    if (tabIndex==0 || tabIndex==1) {
        
//        Commet *commet = (Commet*)[dataArr2 objectAtIndex:indexPath.row];
//        float w = [UIScreen mainScreen].bounds.size.width;
//        CGFloat contentWidth = w - 28 - 16;
//        CGSize size = [GlobalUtil labelHeight:commet.content width:contentWidth fontSize:14];
//        h = size.height+30;
        return UITableViewAutomaticDimension;

    }
    
    
    
    
    
    
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
        
        
        MFMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        
        Commet *commet = (Commet*)[dataArr2 objectAtIndex:indexPath.row];
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
    if (tabIndex==1)
    {
        Commet *commet = (Commet*)[dataArr2 objectAtIndex:indexPath.row];
        reply = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:commet.from error:nil];
        [self showReply];
    }
}


//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (tabIndex==1) {
//        return  44.0f;
//    }
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (tabIndex==1) {
//
//        return [self getFooter];
//    }
//    
//    return nil;
//}

@end
