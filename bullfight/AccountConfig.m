//
//  AccountConfig.m
//  bullfight
//
//  Created by goddie on 15/8/31.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "AccountConfig.h"
#import "ConfigCell.h"
#import "TeamFormCell.h"
#import "ConfigValueCell.h"
#import "UIViewController+Custome.h"
#import "UserPassword.h"

@interface AccountConfig ()

@end

@implementation AccountConfig
{
    NSArray *titleArr;
    NSArray *cellHeight;
    NSArray *cellName;
    NSArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    titleArr = @[
                 @"用户名",
                 @"手机号",
                 @"修改密码"
                 ];
    cellHeight = @[
                   @44.0f,
                   @44.0f,
                   @44.0f
                   ];
    cellName = @[
                 @"ConfigValueCell",
                 @"ConfigValueCell",
                 @"ConfigCell"
                 ];
    
    NSString *username = [GlobalUtil toString:self.user.username];
    NSString *phone = [GlobalUtil toString:self.user.phone];
    dataArr = @[
                username,
                phone
                ];
    
    self.title = @"账户设置";

//    [self addRightNavButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)addRightNavButton
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(0,0,30,30)];
    
        [refreshButton setTitle:@"保存" forState:UIControlStateNormal];
        [refreshButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    refreshButton.userInteractionEnabled = YES;
//    [refreshButton setImage:[UIImage imageNamed:@"nav_btn_settings.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    [refreshButton addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)rightPush
{
//    NSString *uid = [LoginUtil getLocalUUID];
//    if(uid.length==0)
//    {
//        return;
//    }
//    
//    NSString *phone = [self getCellValue:1];
//    
//    NSDictionary *parameters = @{
//                                 @"uid":uid,
//                                 @"phone":phone
//                                 };
//    
//    
//    [self post:@"user/json/regtwo" params:parameters success:^(id responseObj) {
//        
//        NSDictionary *dict = (NSDictionary *)responseObj;
//        
//        if ([[dict objectForKey:@"code"] intValue]==1) {
//            
//            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            //            [alert show];
//            
//            NSDictionary *data = [dict objectForKey:@"data"];
//            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];
//            [LoginUtil saveLocalUser:model];
//            [LoginUtil saveLocalUUID:model];
//            
//            RegThree *c1 = [[RegThree alloc] initWithNibName:@"RegThree" bundle:nil];
//            [self.navigationController pushViewController:c1 animated:YES];
//            
//        }else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
//        
//        
//        
//    }];
}

-(NSString*)getCellValue:(NSInteger)idx
{
    
    TeamFormCell *cell = (TeamFormCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    //        NSLog(@"%d:%@",idx,cell.txt1.text);
    
    if (!cell.txt1.text) {
        return @"";
    }
    return cell.txt1.text;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [cellName objectAtIndex:indexPath.row];
    
    NSString *title = [titleArr objectAtIndex:indexPath.row];
    
    if (indexPath.row==2) {
        ConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        cell.txt.text = title;
        
        return cell;
    }
    
    
    ConfigValueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    cell.txt1.text = title;
    cell.value1.text = [dataArr objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //修改密码
    if (indexPath.row==2) {
        
        UserPassword *c1 = [[UserPassword alloc] initWithNibName:@"UserPassword" bundle:nil];
        
        [self.navigationController pushViewController:c1 animated:YES];
        
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
