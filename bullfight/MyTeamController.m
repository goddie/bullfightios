 //
//  MyTeamController.m
//  bullfight
//  我的队伍
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MyTeamController.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "Team.h"
#import "MyTeamCell.h"
#import "ManaTIController.h"
#import "ManaTIJoinController.h"
#import "TeamCreate.h"
@interface MyTeamController ()

@end

@implementation MyTeamController
{
    NSInteger tabIndex;
    NSString *cellIdentifier;
 
    NSMutableArray *dataArr1;
    NSMutableArray *dataArr2;
    
 
}

static NSString * const reuseIdentifier = @"MyTeamCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    dataArr1 = [NSMutableArray arrayWithCapacity:10];
    dataArr2 = [NSMutableArray arrayWithCapacity:10];
    tabIndex=0;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTeamCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.tableView.backgroundColor = [GlobalConst appBgColor];
    
    
    [self.topView addSubview:[self getTopView]];
    
    self.title = @"我的球队";
    [self addRightNavButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self getData];
}


-(void)addRightNavButton
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(0,0,30,30)];
    
    //    [refreshButton setTitle:@"退出" forState:UIControlStateNormal];
    //    [refreshButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    refreshButton.userInteractionEnabled = YES;
    [refreshButton setImage:[UIImage imageNamed:@"nav_btn_add.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    [refreshButton addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
    
    
}


/**
 *  create team
 */
-(void)rightPush
{
    TeamCreate *c1 = [[TeamCreate alloc] initWithNibName:@"TeamCreate" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
    
}



-(void)getData
{
    NSString *uuid = [LoginUtil getLocalUUID];
    if (uuid.length==0) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uuid
                                 };
    [self showHud];
    
    if (tabIndex==0) {
        [dataArr1 removeAllObjects];
        [self post:@"teamuser/json/mymanateam" params:parameters success:^(id responseObj) {
            NSDictionary *dict = (NSDictionary *)responseObj;
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arr = [dict objectForKey:@"data"];
                NSError *error = nil;
                for (NSDictionary *data in arr) {
                    Team *model = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:data error:&error];
                    if (model!=nil) {
                        [dataArr1 addObject:model];
                    }
                }
                [self.tableView reloadData];
            }
            
            [self hideHud];
        }];
    }
    
    if (tabIndex==1) {
        [dataArr2 removeAllObjects];
        [self post:@"teamuser/json/myteam" params:parameters success:^(id responseObj) {
            NSDictionary *dict = (NSDictionary *)responseObj;
            if ([[dict objectForKey:@"code"] intValue]==1) {
                NSArray *arr = [dict objectForKey:@"data"];
                NSError *error = nil;
                for (NSDictionary *data in arr) {
                    Team *model = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:data error:&error];
                    if (model!=nil) {
                        [dataArr2 addObject:model];
                    }
                }
                [self.tableView reloadData];
            }
            
            [self hideHud];
        }];
    }

    
}

-(UIView*)getTopView
{
    float w = [[UIScreen mainScreen] bounds].size.width;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 50.0f)];
    parent.backgroundColor = [GlobalConst appBgColor];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"我管理的",@"我加入的"]];
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



//SegmentedControl触发的动作

-(void)switchView:(id)sender{
    
    UISegmentedControl *control = (UISegmentedControl *)sender;
    tabIndex = control.selectedSegmentIndex;
    [self getData];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(tabIndex==0)
    {
        return dataArr1.count;
    }
    return dataArr2.count;
}


////选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    MyManaTeamRecord *c1 = [[MyManaTeamRecord alloc] initWithNibName:@"MyManaTeamRecord" bundle:nil];
    //
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c1];
    //
    //    [self presentViewController:nav animated:YES completion:^{
    //
    //    }];
    
    
    
    if (tabIndex==0) {
        
        Team *team = [dataArr1 objectAtIndex:indexPath.row];
        
        ManaTIController *c1 = [[ManaTIController alloc] initWithNibName:@"ManaTIController" bundle:nil];
        c1.team = team;
        c1.uuid = team.uuid;
        
        [self.navigationController pushViewController:c1 animated:YES];
    }
    
    if (tabIndex==1) {
        
        Team *team = [dataArr2 objectAtIndex:indexPath.row];
        
        ManaTIJoinController *c1 = [[ManaTIJoinController alloc] initWithNibName:@"ManaTIJoinController" bundle:nil];
        c1.team = team;
        c1.uuid = team.uuid;

        [self.navigationController pushViewController:c1 animated:YES];
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyTeamCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        [collectionView registerNib:[UINib nibWithNibName:reuseIdentifier  bundle:nil]  forCellWithReuseIdentifier:reuseIdentifier];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    
    Team *entity;
    
    if (tabIndex==0) {
        entity =  (Team*)[dataArr1 objectAtIndex:indexPath.row];
    }
    
    if (tabIndex==1) {
        entity =  (Team*)[dataArr2 objectAtIndex:indexPath.row];
    }
    
    if (!entity.avatar) {
        entity.avatar=@"";
        
        
    }
    
    NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:entity.avatar]];
    [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];

    
    return cell;
    
    //
    //    static NSString *userMatchCell = @"TeamCell";
    //
    //
    //    TeamCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:userMatchCell forIndexPath:indexPath];
    //    if (!cell) {
    //        [collectionView registerNib:[UINib nibWithNibName:userMatchCell bundle:nil]  forCellWithReuseIdentifier:userMatchCell];
    //        //[collectionView registerNib:[UINib nibWithNibName:userMatchCell bundle:nil] forCellReuseIdentifier:userMatchCell];
    //        cell = [collectionView dequeueReusableCellWithReuseIdentifier:userMatchCell forIndexPath:indexPath];
    //    }
    //
    //    return cell;
    
    
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(95, 95);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);//分别为上、左、下、右
}
////返回头headerView的大小
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    CGSize size={320,45};
//    return size;
//}
////返回头footerView的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    CGSize size={320,45};
//    return size;
//}
////每个section中不同的行之间的行间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}
////每个item之间的间距
////- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
////{
////    return 100;
////}
////选择了某个cell
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor greenColor]];
//}
////取消选择了某个cell
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor redColor]];
//}
@end
