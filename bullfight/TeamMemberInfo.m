//
//  TeamMemberInfo.m
//  bullfight
//
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TeamMemberInfo.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "TeamMemberInfoCell.h"
#import "MyButton.h"
#import "TeamMemberAdd.h"
#import "TeamMemberAdmin.h"

@interface TeamMemberInfo ()

@end

@implementation TeamMemberInfo
{
    NSMutableArray *dataArr;
    User *delUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self globalConfig];
    [self setExtraCellLineHidden:self.tableView];
    self.title = @"队员管理";
    
    dataArr =[NSMutableArray arrayWithCapacity:10];
    [self getData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)kickClick:(MyButton*)sender
{
    delUser = (User*)sender.data;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"踢出队伍" message:@"确定将该成员踢出队伍?" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确定", nil];
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    
    if (buttonIndex==0) {
        return;
    }
    
    NSString *uid = [LoginUtil getLocalUUID];
    if(!uid)
    {
        return;
    }
    
    
    if(!self.team)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"tid":self.team.uuid,
                                 @"uid":delUser.uuid
                                 };
    
//    __weak TeamMemberInfo * wself = self;
    [self post:@"teamuser/json/quit" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            [dataArr removeObject:delUser];
            
            [self.tableView reloadData];
            
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        

        
        //[wself.navigationController popViewControllerAnimated:YES];
        
    }];
    
}


-(UIView*)getTopView
{
    float w = [UIScreen mainScreen].bounds.size.width;
    float w2 = 120+20+120;
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 120)];
    
    MyButton *btn1 = [[MyButton alloc] initWithFrame:CGRectMake((w-w2)*0.5f, 15, 120, 30)];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btn1 setTitle:@"添加球员" forState:UIControlStateNormal];
    [GlobalUtil set9PathImage:btn1 imageName:@"shared_btn_small.png" top:2.0f right:10.0f];
    [parent addSubview:btn1];
    [btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    
    
    MyButton *btn2 = [[MyButton alloc] initWithFrame:CGRectMake(btn1.frame.origin.x+20+120, 15, 120, 30)];
    btn2.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btn2 setTitle:@"更换队长" forState:UIControlStateNormal];
    [GlobalUtil set9PathImage:btn2 imageName:@"shared_btn_small.png" top:2.0f right:10.0f];
    [parent addSubview:btn2];
    [btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    
    parent.backgroundColor= [GlobalConst appBgColor];
    
    return parent;
}


-(void)btn1Click
{
    TeamMemberAdd *c1 = [[TeamMemberAdd alloc] initWithNibName:@"TeamMemberAdd" bundle:nil];
    c1.team = self.team;
    [self.navigationController pushViewController:c1 animated:YES];
    
    
}


-(void)btn2Click
{
    TeamMemberAdmin *c1 = [[TeamMemberAdmin alloc] initWithNibName:@"TeamMemberAdmin" bundle:nil];
    c1.team = self.team;
    [self.navigationController pushViewController:c1 animated:YES];
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
    [cell.btn1 setTitle:@"踢出队伍" forState:UIControlStateNormal];
    
    
    [GlobalUtil addButtonToView:self sender:cell.btn1 action:@selector(kickClick:) data:entity];
    
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getTopView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
