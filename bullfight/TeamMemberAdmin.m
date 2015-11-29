//
//  TeamMemberAdmin.m
//  bullfight
//
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TeamMemberAdmin.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "TeamMemberInfoCell.h"
#import "MyButton.h"

@interface TeamMemberAdmin ()

@end

@implementation TeamMemberAdmin
{
    NSMutableArray *dataArr;
    User *delUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    self.tableView.backgroundColor = [GlobalConst appBgColor];
    
    dataArr= [NSMutableArray arrayWithCapacity:10];
    
    self.title = @"更换队长";
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  更换新队长
 *
 *  @param sender <#sender description#>
 */
-(void)admin:(MyButton*)sender
{
    User *user = (User*)sender.data;
    
    if (!self.team) {
        return;
    }
    
    NSString *uuid = [LoginUtil getLocalUUID];
    
    if (!uuid) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"newid":user.uuid,
                                 @"oldid":uuid,
                                 @"tid":self.team.uuid
                                 };
    
    [self post:@"team/json/admin" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }];
    
}




-(void)getData
{
    if(!self.team)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"tid":self.team.uuid,
                                 @"p":@"1"
                                 };
    [self post:@"teamuser/json/memberlist" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
            NSError *error = nil;
            
            for (NSDictionary *data in arr) {
                User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
                if (model!=nil) {
                    [dataArr addObject:model];
                }
            }
        }
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TeamMemberInfoCell";
    
    TeamMemberInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    User *entity = [dataArr objectAtIndex:indexPath.row];
    
    if (entity.avatar) {
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:entity.avatar]];
        [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }

    
    cell.txt1.text = entity.nickname;
    cell.txt2.text = entity.position;
    [cell.btn1 setTitle:@"选为队长" forState:UIControlStateNormal];
    
    
    
    [GlobalUtil addButtonToView:self sender:cell.btn1 action:@selector(admin:) data:entity];
    
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

@end
