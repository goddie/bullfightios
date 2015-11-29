 //
//  MyTeamController.m
//  bullfight
//
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchAcceptTeam.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "Team.h"
#import "MyTeamCell.h"
#import "ManaTIController.h"
#import "ManaTIJoinController.h"
#import "MCTeam.h"
#import "MatchAccept.h"

@interface MatchAcceptTeam ()

@end

@implementation MatchAcceptTeam
{
    NSString *cellIdentifier;
 
    NSMutableArray *dataArr1;
    
    Team *curTeam;
    
    NSInteger rowIndex;
}

static NSString * const reuseIdentifier = @"MyTeamCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    dataArr1 = [NSMutableArray arrayWithCapacity:10];
    
 
    
    rowIndex = 0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTeamCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.tableView.backgroundColor = [GlobalConst appBgColor];
    
    [self getData];
    
    self.title = @"球队";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData
{
    NSString *uuid = [LoginUtil getLocalUUID];
    if (!uuid.length) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uuid
                                 };
    
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
    }];
    
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (!curTeam) {
        return;
    }
    
    if ([viewController isKindOfClass:[MCTeam class]]) {
//        NSLog(@"%@",tid);
        MCTeam *mcTeam = (MCTeam*)viewController;
        mcTeam.team  = curTeam;
        mcTeam.matchFight.host = @{@"hostid":curTeam.uuid};
        
        [mcTeam bindTeam];
    }
    

}


-(void)selectTeam
{
    MatchAccept *c1 = [[MatchAccept alloc] initWithNibName:@"MatchAccept" bundle:nil];
    c1.matchFight = self.matchFight;
    c1.team = curTeam;
    [self.navigationController pushViewController:c1 animated:YES];
    
//    NSDictionary *team = [dataArr1 objectAtIndex:rowIndex];
//    
//    NSDictionary *dict = @{@"tid":[arena objectForKey:@"id"],@"name":[arena objectForKey:@"name"]};
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter postNotificationName:@"selectTeam" object:curTeam];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArr1.count;
}


////选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    Team *team = [dataArr1 objectAtIndex:indexPath.row];
    
    curTeam  = [dataArr1 objectAtIndex:indexPath.row];;
    
//    MCTeam *mcTeam = (MCTeam*)[self.navigationController.viewControllers objectAtIndex:0];

    [self selectTeam];
//    [self.navigationController popViewControllerAnimated:YES];
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyTeamCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        [collectionView registerNib:[UINib nibWithNibName:reuseIdentifier  bundle:nil]  forCellWithReuseIdentifier:reuseIdentifier];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    
 
    
    Team *entity;
    
    entity =  (Team*)[dataArr1 objectAtIndex:indexPath.row];
    
    if (entity.avatar) {
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:entity.avatar]];
        [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }else
    {
        cell.img1.image = [UIImage imageNamed:@"holder.png"];
    }
 

    
    return cell;
    
    
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
