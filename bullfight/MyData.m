//
//  MyData.m
//  bullfight
//
//  Created by goddie on 15/8/19.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MyData.h"
#import "MyDataTopCell.h"
#import "MyDataCell.h"
#import "MatchFinishCell.h"
#import "UIViewController+Custome.h"
#import "MatchFight.h"

@interface MyData ()

@end

@implementation MyData
{
    NSArray *cellArr;
    NSInteger tabIndex;
    NSString *cellIdentifier;
    NSArray *dataArr;
    NSArray *cellHeightArr;
    
    NSArray *titleArr;
    
    NSArray *dataArr1;
    NSMutableArray *dataArr2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    self.tableView.backgroundColor = [GlobalConst appBgColor];
    
    [self.topView addSubview:[self getTopView]];
    
//    top = [[TITop alloc] initWithNibName:@"TITop" bundle:nil];
//    [self addChildViewController:top];
//    top.parent = self;
    
    cellHeightArr = @[
                      @[@60,@130],
                      @[@190]
                      ];
    cellArr = @[
                @[@"MyDataCell",@"MyDataTopCell"],
                @[@"MatchFinishCell"]
                ];
    dataArr = @[
                @[@"1",@"1",@"1",@"1"],
                @[@"1",@"1",@"1",@"1"]
                ];
    
    titleArr = @[
                  @[@"参赛场数",@"得分总数"],
                  @[@"场均得分",@"命中率"],
                  @[@"场均三分",@"命中率"],
                  @[@"场均篮板",@"场均助攻"],
                  @[@"场均盖帽",@"场均抢断"]
                  ];
    dataArr1 = @[];
    dataArr2 = [NSMutableArray arrayWithCapacity:10];
    
    tabIndex = 0;
    
    cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:0];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)switchView:(id)sender{
    
    UISegmentedControl *control = (UISegmentedControl *)sender;
    tabIndex = control.selectedSegmentIndex;
    cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:0];
    
    
    if (tabIndex==0) {
        [self getData];
    }
    
    if (tabIndex==1) {
        [self getMatchFight];
    }
    
}

-(void)getData
{
    NSString *uid = [LoginUtil getLocalUUID];
    if (uid.length==0) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uid
                                 };
    
    
    [self post:@"user/json/getuser" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [dict objectForKey:@"data"];
            NSError *error = nil;
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
            NSLog(@"%@",[error description]);
            
            if (model!=nil) {
                dataArr1 = @[
                             @[model.playCount,model.scoring],
                             @[model.scoringAvg,model.goalPercent],
                             @[model.threeGoal,model.threeGoalPercent],
                             @[model.rebound,model.assist],
                             @[model.block,model.steal]
                             ];
                
                [self.tableView reloadData];
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        
        
    }];

}

-(void)getMatchFight
{
//    User *user = [LoginUtil getUserFromLocalJSON];
//    if(user==nil)
//    {
//        
//    }
    
    NSString *uid = [LoginUtil getLocalUUID];
    if (uid.length==0) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uid
                                 };
    
    [dataArr2 removeAllObjects];
    
    [self post:@"matchdatauser/json/usermatch" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
            NSError *error = nil;
            
            for (NSDictionary *data in arr) {
                MatchFight *model = [MTLJSONAdapter modelOfClass:[MatchFight class] fromJSONDictionary:data error:&error];
                
                NSLog(@"%@",[error description]);
                
                if (model!=nil) {
                    
                    [dataArr2 addObject:model];
                    

                }

            }
            
            
            [self.tableView reloadData];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        
        
    }];
    
}



-(UIView*)getTopView
{
    float w = [[UIScreen mainScreen] bounds].size.width;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 50.0f)];
    parent.backgroundColor = [GlobalConst appBgColor];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"综合数据",@"单场数据"]];
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
    
    if (tabIndex==0) {
        return dataArr1.count;
    }
    if (tabIndex==1) {
        return dataArr2.count;
    }

    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int h  =[[[cellHeightArr objectAtIndex:tabIndex] objectAtIndex:0] intValue];
    
    if (tabIndex==0&&indexPath.row==0) {
        h = [[[cellHeightArr objectAtIndex:tabIndex] objectAtIndex:1] intValue];
    }
    
    return h;
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tabIndex==0) {
        
        if(indexPath.row==0)
        {
            cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:1];
            MyDataTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
                cell = [nibArray objectAtIndex:0];
            }
            
            cell.lab1.text = [GlobalUtil toString:[[titleArr objectAtIndex:indexPath.row ] objectAtIndex:0]];
            cell.lab2.text = [GlobalUtil toString:[[titleArr objectAtIndex:indexPath.row] objectAtIndex:1]];
            cell.txt1.text = [GlobalUtil toString:[[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:0]];
            cell.txt2.text = [GlobalUtil toString:[[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:1]];
            
            return cell;
        }
        
        cellIdentifier = [[cellArr objectAtIndex:tabIndex] objectAtIndex:0];
        
        MyDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        cell.lab1.text = [GlobalUtil toString:[[titleArr objectAtIndex:indexPath.row] objectAtIndex:0]];
        cell.lab2.text = [GlobalUtil toString:[[titleArr objectAtIndex:indexPath.row] objectAtIndex:1]];
        cell.txt1.text = [GlobalUtil toString:[[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:0]];
        cell.txt2.text = [GlobalUtil toString:[[dataArr1 objectAtIndex:indexPath.row] objectAtIndex:1]];
        
        
        return cell;
        
    }
    
    if (tabIndex==1) {
        
        
        
        MatchFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        //cell.txt1.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
        MatchFight *model  = [dataArr2 objectAtIndex:indexPath.row];
        
        cell.txtScore.text = [NSString stringWithFormat:@"%@:%@",[GlobalUtil toString:model.hostScore],[GlobalUtil toString:model.guestScore]];
        cell.txtNum1.text = [GlobalUtil toString:model.teamSize];
        cell.txtNum2.text = [GlobalUtil toString:model.teamSize];;
        
        cell.txtPlace.text = [model.arena objectForKey:@"name"];
        cell.txtDate.text = [GlobalUtil getDateFromUNIX:model.end];
        
        cell.txtTeam1.text = [model.host objectForKey:@"name"];
        cell.txtTeam2.text = [model.guest objectForKey:@"name"];
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
    
    //    UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    //    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
//    MFController *c1= [[MFController alloc] initWithNibName:@"MFController" bundle:nil];
//    c1.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:c1 animated:YES];
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
