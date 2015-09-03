//
//  SysConfig.m
//  bullfight
//
//  Created by goddie on 15/8/28.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "SysConfig.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"
#import "ArenaCell.h"
#import "AppDelegate.h"
#import "ConfigCell.h"
#import "AccountConfig.h"
#import "Feedback.h"
#import "About.h"

@interface SysConfig ()



@end

@implementation SysConfig
{
    NSArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    dataArr = @[
                
                //@[@"账户设置",@"帐号连接"],
                @[@"账户设置"],
                @[@"关于来斗牛",@"意见反馈",@"微信公众号"],
//                 @[@"银行卡",@"支付密码"],
//                 @[@"通知设置",@"帮助"],
//                 @[@"清空缓存"],
                 @[@"退出登录"],
                ];
    
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logout
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [LoginUtil clearLocal];
    [[AppDelegate delegate] loginPage];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self logout];
        }
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return [[dataArr objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    static NSString *cellIdentifier = @"ConfigCell";
    
    ConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    
    cell.txt.text = [[dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return  cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        //账户设置
        if (indexPath.row == 0) {
            
            AccountConfig *c1 = [[AccountConfig alloc] initWithNibName:@"AccountConfig" bundle:nil];
            c1.user = self.user;
            [self.navigationController pushViewController:c1 animated:YES];
            
        }
        
        //账号连接
        if (indexPath.row == 1) {
            
            
            
        }
        
    }
    
    
    if (indexPath.section==1) {
        
        //关于来斗牛
        if (indexPath.row == 0) {
            
            About *c1 = [[About alloc] initWithNibName:@"About" bundle:nil];
            [self.navigationController pushViewController:c1 animated:YES];
            
        }
        
        //意见反馈
        if (indexPath.row == 1) {
            
            Feedback *c1 = [[Feedback alloc] initWithNibName:@"Feedback" bundle:nil];
            [self.navigationController pushViewController:c1 animated:YES];
            
        }

        


    }
    
    
    if (indexPath.section==2) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认退出吗" message:@"退出后不会删除任何历史数据，下次登录仍然可以使用本账号。" delegate:self cancelButtonTitle:@"取消操作" otherButtonTitles:@"确认退出", nil];
        
        alert.tag = 100;
        
        [alert show];
        

    }

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
