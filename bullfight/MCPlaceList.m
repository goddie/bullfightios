//
//  MCPlaceList.m
//  bullfight
//
//  Created by goddie on 15/8/24.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MCPlaceList.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "ArenaCell.h"
#import "MCPlace.h"



@interface MCPlaceList ()

@end

@implementation MCPlaceList
{
    UIView *headerView;
    NSMutableArray *dataArr;
    NSInteger rowIndex;
    NSNumber *curPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    self.title = @"选择场地";
    [self addRightNavButton];
    

    

    
    dataArr = [NSMutableArray arrayWithCapacity:10];
    
    rowIndex = 0;
    
    curPage = [NSNumber numberWithInt:1];
    __weak MCPlaceList *wkSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [wkSelf refresh];
        
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [wkSelf loadMore];
        
    }];
    
    
    [self loadData];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView setTableFooterView:v];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addRightNavButton
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(0,0,30,30)];
    
    //    [refreshButton setTitle:@"退出" forState:UIControlStateNormal];
    //    [refreshButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    refreshButton.userInteractionEnabled = YES;
    [refreshButton setImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    [refreshButton addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
    
    
}


-(void)rightPush
{
    self.tableView.tableHeaderView = [self getTop];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSString *searchTerm = searchBar.text;
    
    if(!searchTerm)
    {
        return;
    }
    
    
    [self.view endEditing:YES];
    
    NSDictionary *parameters = @{
                                 @"key":searchTerm
                                 };
    [dataArr removeAllObjects];
    [self showHud ];
    [self post:@"arena/json/search" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
//            NSError *error = nil;
            
            for (NSDictionary *data in arr) {
                //Arean *model = [MTLJSONAdapter modelOfClass:[Arean class] fromJSONDictionary:data error:&error];
//                if (model!=nil) {
//                    [dataArr addObject:model];
//                }
                [dataArr addObject:data];
            }
            
            [self.tableView reloadData];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        [self hideHud];
    }];
    
}

-(void)loadData
{
    [self showHud];
    
    NSDictionary *parameters = @{
                                 @"p":curPage
                                 };
//    [dataArr removeAllObjects];
    [self post:@"arena/json/list" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
            NSError *error = nil;
            
            for (NSDictionary *data in arr) {
                if (data.count) {
                    [dataArr addObject:data];
                }
            }
        }
        
        [self.tableView reloadData];
        [self stopAnimation];
    }];
    
}



//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (![viewController isKindOfClass:[MCPlace class]]) {
//        return;
//    }
//    
//    if (dataArr.count==0) {
//        return;
//    }
//    
//    MCPlace *c1 = (MCPlace*)viewController;
//    c1.matchFight.arena = @{@"aid":[[dataArr objectAtIndex:rowIndex] objectForKey:@"id"]};
//    
//    c1.arenaid = [[dataArr objectAtIndex:rowIndex] objectForKey:@"id"];
//    c1.arenaName = [[dataArr objectAtIndex:rowIndex] objectForKey:@"name"];
//    
//    [c1 bindArena];
//}


-(void)refresh
{
    [dataArr removeAllObjects];
    curPage = [NSNumber numberWithInt:1];
    [self loadData];
}

-(void)loadMore
{
    curPage = [NSNumber numberWithInt: [curPage intValue] + 1];
    
    [self loadData];
}

-(void)stopAnimation
{
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView.infiniteScrollingView stopAnimating];
    [self hideHud];
}

-(UIView*)getTop
{
    if (headerView!=nil) {
        return headerView;
    }
    
    float w = [UIScreen mainScreen].bounds.size.width;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 60)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 15, w-40, 30)];
    
    searchBar.delegate = self;
    //searchBar.barStyle = UIBarStyleBlackTranslucent;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.placeholder = @"输入球场";
    searchBar.keyboardType =  UIKeyboardTypeDefault;
    
    [searchBar setBackgroundColor:[GlobalConst appBgColor]];
    [searchBar setBarTintColor:[GlobalConst appBgColor]];
    searchBar.clipsToBounds = YES;
    
    //UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, w - 20, 30)];
    //[GlobalUtil set9PathImage:bgImage imageName:@"shared_big_btn.png" top:2 right:10];
    
    //    [segment addSubview: bgImage];
    
    headerView.backgroundColor = [GlobalConst appBgColor];
    [headerView addSubview:searchBar];
    //    [parent addSubview:bgImage];
    
    return headerView;

}

-(void)selectPlace
{
    NSDictionary *arena = [dataArr objectAtIndex:rowIndex];
    
    NSDictionary *dict = @{@"aid":[arena objectForKey:@"id"],@"name":[arena objectForKey:@"name"]};
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"selectPlace" object:dict];
}

#pragma mark - Table view data source
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [self getTop];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"ArenaCell";
 
    
    ArenaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    if (dataArr.count==0) {
        return  cell;
    }
    
    cell.txt1.text = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    if (!self.isFree) {
        
        NSString *price = [GlobalUtil toString:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"price"]];
        
        cell.txt2.text = [NSString stringWithFormat:@"%@元",price];
    }
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    rowIndex  = indexPath.row;
    
    [self selectPlace];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
