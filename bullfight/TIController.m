//
//  TIController.m
//  bullfight
//  球队信息
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TIController.h"
#import "TITop.h"
#import "MatchFinishCell.h"
#import "TIPositionCell.h"
#import "TITeamDataCell.h"
#import "UIViewController+Custome.h"
#import "Team.h"
#import "UIImageView+WebCache.h"
#import "MatchFight.h"
#import "User.h"

@interface TIController ()

@end

@implementation TIController


NSArray *cellArr;
NSInteger tabIndex = 0;
NSString *cellIdentifier;
NSArray *dataArr;
NSArray *cellHeightArr;
NSInteger topHeight;

NSMutableArray *dataArr1;
NSMutableArray *dataArr2;
NSMutableArray *dataArr3;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
     self.tableView.backgroundColor  = [GlobalConst lightAppBgColor];
    
    [self initData];
    [self getTop];
    [self getData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData
{
    cellHeightArr = @[
                      @[@190,@44],
                      @[@70],
                      @[@62],
                      @[@190]
                      ];
    topHeight =335;
    cellArr = @[
                @[@"MatchFinishCell",@"TeamDataCell"],
                @[@"TIPositionCell"],
                @[@"TITeamDataCell"],
                @[@"MatchFinishCell"]
                
                ];
    
    cellIdentifier = [cellArr objectAtIndex:tabIndex];

    dataArr1 = [NSMutableArray arrayWithCapacity:10];
    dataArr2 = [NSMutableArray arrayWithCapacity:10];
    dataArr3 = [NSMutableArray arrayWithCapacity:10];

}

-(UIView*)getTop
{
    TITop *top = [[TITop alloc] initWithNibName:@"TITop" bundle:nil];
    top.team = self.team;
    [self addChildViewController:top];
    return top.view;
}


-(void)changeTab:(NSInteger)idx
{
    tabIndex = idx;
    cellIdentifier = [cellArr objectAtIndex:tabIndex];
    [self.tableView reloadData];
    [self getTabData];
}


-(void)getTabData
{
    //战绩
    if (tabIndex==0) {
 
        if (self.uuid.length==0) {
            return;
        }
        
        NSDictionary *parameters = @{
                                     @"tid":self.uuid
                                     };
        
        [dataArr1 removeAllObjects];
        [self post:@"matchdatateam/json/teammatch" params:parameters success:^(id responseObj) {
            NSDictionary *dict = (NSDictionary *)responseObj;
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arr = [dict objectForKey:@"data"];
                NSError *error = nil;
                for (NSDictionary *data in arr) {
                    MatchFight *model = [MTLJSONAdapter modelOfClass:[MatchFight class] fromJSONDictionary:data error:&error];
//                    NSLog(@"%@",[error description]);
                    if (model!=nil) {
                        [dataArr1 addObject:model];
                    }
                }
                [self.tableView reloadData];
            }
        }];
    }
    
    
    //阵容
    if (tabIndex==1) {
        
        if (self.uuid.length==0) {
            return;
        }
        
        NSDictionary *parameters = @{
                                     @"tid":self.uuid
                                     };
        
        [dataArr2 removeAllObjects];
        
        [self post:@"matchdatateam/json/teammatch" params:parameters success:^(id responseObj) {
            
            NSDictionary *dict = (NSDictionary *)responseObj;
            
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arr = [dict objectForKey:@"data"];
                NSError *error = nil;
                
                for (NSDictionary *data in arr) {
                    User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
//                    NSLog(@"%@",[error description]);
                    if (model!=nil) {
                        [dataArr2 addObject:model];
                    }
                }
                [self.tableView reloadData];
                
            }
            
            
        }];
    }
    
    //数据
    if (tabIndex==2) {
        
        
        
        
    }
    
    //荣誉
    if (tabIndex==3) {
        
    }
}


-(void)getData
{

    if(!self.uuid)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"tid":self.uuid
                                 };
    
    [self post:@"team/json/getteam" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            NSDictionary *data = [dict objectForKey:@"data"];
            
            _team = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:data error:nil];
            
        }
        
    }];

    
}


//-(void)bindTeam
//{
// 
//    NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:entity.avatar]];
//    [top.img sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
//    
//    
//    top.txtFound.text = [GlobalUtil getDateFromUNIX:entity.createdDate];
//    top.txtName.text = entity.name;
//    top.txtInfo.text = entity.info;
//}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tabIndex==0) {
        return dataArr1.count;
    }
    
    if (tabIndex==1) {
        return dataArr2.count;
    }
    
    if (tabIndex==2) {
        return dataArr3.count;
    }
    
    if (tabIndex==3) {
        return 0;
    }
    
    
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tabIndex==0 && indexPath.row==0)
    {
        return [[[cellHeightArr objectAtIndex:tabIndex] objectAtIndex:1] intValue];
    }
    
    int h  =[[[cellHeightArr objectAtIndex:tabIndex] objectAtIndex:0] intValue];
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tabIndex==0) {
        
        MatchFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        //cell.txt1.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        
        return cell;
        
    }
    
    if (tabIndex==1) {
        
        TIPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
       // cell.txtName.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        
        return cell;
        
    }
    
    
    if (tabIndex==2) {
        
        TITeamDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        //cell.txtPos.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        
        
        return cell;
        
    }
    
    
    if (tabIndex==3) {
        
        MatchFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
    return topHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getTop];
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
