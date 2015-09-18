//
//  PlayerList.m
//  bullfight
//
//  Created by goddie on 15/9/16.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "PlayerList.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "TIPositionCell.h"
#import "MIController.h"
#import "User.h"

@interface PlayerList ()

@end

@implementation PlayerList
{
    NSMutableArray *dataArr;
    
    NSNumber *curPage;
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"牛丸圈";
    
    [self globalConfig];
    //[self addRightNavButton];
    [self setExtraCellLineHidden:self.tableView];
    
//    self.navigationItem.titleView = [self getTopView];
    
    dataArr =  [NSMutableArray arrayWithCapacity:10];
 
    curPage = [NSNumber numberWithInt:1];
    
    __weak PlayerList *wkSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [wkSelf refresh];
        
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [wkSelf loadMore];
        
    }];
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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


-(void)addRightNavButton
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0,0,26,30)];
    rightBtn.userInteractionEnabled = YES;
    [rightBtn setImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    [rightBtn addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
}

-(void)rightPush
{
    
}

-(UIView*)getTopView
{
    float w = [[UIScreen mainScreen] bounds].size.width;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 40.0f)];
    //    parent.backgroundColor = [UIColor yellowColor];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"牛Games",@"牛Style",@"牛Issue"]];
    segmentedControl.layer.borderColor = [[GlobalConst tabTintColor] CGColor];
    segmentedControl.layer.borderWidth = 2.0f;
    
    
    segmentedControl.layer.masksToBounds = YES;
    segmentedControl.layer.cornerRadius = 15.0f;
    segmentedControl.frame = CGRectMake(15.0f, 5.0f, w-50, 30.0f);
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

-(void)switchView:(id)sender{
    
    UISegmentedControl *control = (UISegmentedControl *)sender;
    //    tabIndex = control.selectedSegmentIndex;
    //
    //    if (tabIndex==0) {
    //        matchType = [NSNumber numberWithInt:1];
    //    }
    //    if (tabIndex==1) {
    //        matchType = [NSNumber numberWithInt:2];
    //    }
    //
    //    [dataArr2 removeAllObjects];
    //    curPage = [NSNumber numberWithInt:1];
    //    [self loadData];
    
}
/**
 *  玩家列表
 */
-(void)loadData
{
    
    [self showHud];
    
    NSDictionary *parameters = @{
                                 @"p":curPage
                                 };
    
    [self post:@"user/json/list" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
            //NSError *error = nil;
            
            for (NSDictionary *data in arr) {
                
                User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];
                //                    NSLog(@"%@",[error description]);
                if (model!=nil) {
                    [dataArr addObject:model];
                }

                
                

            }
            
        }
        
        [self.tableView reloadData];
        [self stopAnimation];
    }];
    
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSString *searchTerm = searchBar.text;
    
    if(!searchTerm)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"nickname":searchTerm,
                                 @"p":curPage
                                 };
    
    [dataArr removeAllObjects];
    curPage = [NSNumber numberWithInteger:1];
    [self showHud];
    [self post:@"user/json/searchuser" params:parameters success:^(id responseObj) {
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
            
            [self.tableView reloadData];
        }
        [self stopAnimation];
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
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellIdentifier = @"TIPositionCell";
    
    
 
    
    
    
    TIPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    if (dataArr.count==0) {
        return cell;
    }
    
    User *entity = (User*)[dataArr objectAtIndex:indexPath.row];
    // cell.txtName.text = [[dataArr objectAtIndex:tabIndex] objectAtIndex:indexPath.row];
    
    cell.txtName.text = [GlobalUtil toString:entity.nickname];
    
    
    cell.txtPos.text = [GlobalUtil toString:entity.position];
    cell.txtWeight.text = [NSString stringWithFormat:@"身高:%@cm",[GlobalUtil toString:entity.weight]];
    cell.txtHeight.text = [NSString stringWithFormat:@"体重:%@kg",[GlobalUtil toString:entity.height]];
    
    if(entity.avatar)
    {
        NSString *a2 = [@"" stringByAppendingString:entity.avatar];
        NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a2]];
        [cell.img1 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
    
    return cell;

 
    
//    if (avatr) {
//
//        NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:avatr]];
//        [cell.img1 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
//    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    User *user = [dataArr objectAtIndex:indexPath.row];
    
    MIController *c1 = [[MIController alloc] initWithNibName:@"MIController" bundle:nil];
    
    c1.user = user;
    
    [self.navigationController pushViewController:c1 animated:YES];
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float w = [UIScreen mainScreen].bounds.size.width;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 60)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 15, w-40, 30)];
    
    searchBar.delegate = self;
    //searchBar.barStyle = UIBarStyleBlackTranslucent;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.placeholder = @"输入球员昵称";
    searchBar.keyboardType =  UIKeyboardTypeDefault;
    
    [searchBar setBackgroundColor:[UIColor clearColor]];
    [searchBar setBarTintColor:[UIColor clearColor]];
    searchBar.clipsToBounds = YES;
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, w - 20, 30)];
    [GlobalUtil set9PathImage:bgImage imageName:@"shared_big_btn.png" top:2 right:10];
    
    //    [segment addSubview: bgImage];
    
    [parent addSubview:searchBar];
    //    [parent addSubview:bgImage];
    
    return parent;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
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
