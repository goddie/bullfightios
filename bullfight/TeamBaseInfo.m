//
//  TeamBaseInfo.m
//  bullfight
//  球队基本资料
//  Created by goddie on 15/8/21.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TeamBaseInfo.h"
#import "TeamFormCell.h"
#import "TeamFormInfoCell.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"

@interface TeamBaseInfo ()

@end

@implementation TeamBaseInfo
{
    NSArray *titleArr;
    NSArray *cellHeight;
    NSArray *cellName;
    
    
    NSMutableArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    titleArr = @[
                @"球队名称",
                @"城市",
                @"成立时间",
                @"球队简介"
                ];
    cellHeight = @[
                   @44.0f,
                   @44.0f,
                   @44.0f,
                   @100.0f
                   ];
    cellName = @[
                 @"TeamFormCell",
                 @"TeamFormCell",
                 @"TeamFormCell",
                 @"TeamFormInfoCell"
                 ];
    
    
    dataArr = [NSMutableArray arrayWithCapacity:10];
    
    
    [self bindData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bindData
{
    [dataArr addObject:self.team.name];
    [dataArr addObject:self.team.city];
    [dataArr addObject:[GlobalUtil getDateFromUNIX:self.team.createdDate]];
    [dataArr addObject:self.team.info];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return titleArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = [[cellHeight objectAtIndex:indexPath.row] intValue];
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [cellName objectAtIndex:indexPath.row];
    
    
    if (indexPath.row==3) {
        TeamFormInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        cell.lab1.text = [titleArr objectAtIndex:indexPath.row];
        cell.txt1.text = [dataArr objectAtIndex:indexPath.row];
        
        return cell;
    }
    
    TeamFormCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    cell.lab1.text = [titleArr objectAtIndex:indexPath.row];
    cell.txt1.text = [dataArr objectAtIndex:indexPath.row];
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float w = [UIScreen mainScreen].bounds.size.width;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 60)];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((w-90)*0.5f, 20, 90, 90)];
    [GlobalUtil setMaskImageQuick:imageView withMask:@"round_mask.png" point:CGPointMake(90.0f, 90.0f)];
    
    
    if (self.team.avatar) {
        NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.team.avatar]];
        [imageView sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }

    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((w-120)*0.5f, imageView.frame.origin.y + imageView.frame.size.height + 20, 120, 30)];
    [GlobalUtil set9PathImage:btn imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [btn setTitle:@"更换队徽" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    
    [parent addSubview:imageView];
    [parent addSubview:btn];
    
    return parent;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 220;
}

@end
