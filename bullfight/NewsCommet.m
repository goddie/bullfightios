//
//  NewsCommet.m
//  bullfight
//  新闻评论
//  Created by goddie on 15/11/29.
//  Copyright © 2015年 santao. All rights reserved.
//

#import "NewsCommet.h"
#import "MFMessageCell.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "Commet.h"
#import "User.h"
#import "AddMessage.h"
#import "MyButton.h"
#import "MIController.h"

@interface NewsCommet ()

@end

@implementation NewsCommet
{
    NSMutableArray *dataArr;
    NSNumber *curPage;
    User *reply;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    
    self.tableView.backgroundColor  = [GlobalConst appBgColor];
    
    [self setExtraCellLineHidden:self.tableView];
    
    self.title = @"评论";
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self addRightNavButton];
    curPage = [NSNumber numberWithInt:1];
    __weak NewsCommet *wkSelf = self;
    
    dataArr = [NSMutableArray arrayWithCapacity:10];
    
    [self getData];
    
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

- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];

}

-(void)refresh
{
    [dataArr removeAllObjects];
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




-(void)addRightNavButton
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0,0,50,30)];
    rightBtn.userInteractionEnabled = YES;
    [rightBtn setTitle:@"写评论" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    //[rightBtn setImage:[UIImage imageNamed:@"nav_filter.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    [rightBtn addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
}


-(void)rightPush
{
    AddMessage *c1 = [[AddMessage alloc] initWithNibName:@"AddMessage" bundle:nil];
    c1.aid = self.aid;
    [self.navigationController pushViewController:c1 animated:YES];
}



-(void)getData
{
    NSDictionary *parameters = @{
                                 @"aid":self.aid,
                                 @"p":curPage
                                 };
    [self showHud];
    
    [self post:@"commet/json/list" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
            
            if (arr.count>0) {
                [dataArr removeAllObjects];
            }
            NSError *error = nil;
            for (NSDictionary *data in arr) {
                Commet *model = [MTLJSONAdapter modelOfClass:[Commet class] fromJSONDictionary:data error:&error];
                if (model!=nil) {
                    [dataArr addObject:model];
                }
            }
            
            
            [self.tableView reloadData];
            
            
        }
        
        [self stopAnimation];
        
    }];

}


-(void)openMember:(id)sender
{
    MyButton *btn = (MyButton*)sender;
    
    MIController *c1 = [[MIController alloc] initWithNibName:@"MIController" bundle:nil];
    c1.user = (User*)btn.data;
    [self.navigationController pushViewController:c1 animated:YES];
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
        c1.aid = self.aid;
        c1.reply = reply;
        [self.navigationController pushViewController:c1 animated:YES];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MFMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MFMessageCell"];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"MFMessageCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    
    if (dataArr.count==0) {
        return  cell;
    }
    
    Commet *commet = (Commet*)[dataArr objectAtIndex:indexPath.row];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Commet *commet = (Commet*)[dataArr objectAtIndex:indexPath.row];
    reply = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:commet.from error:nil];
    [self showReply];
}



@end
