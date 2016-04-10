//
//  TeamMemberAdd.m
//  bullfight
//
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TeamMemberAdd.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "TeamMemberInfoCell.h"
#import "MyButton.h"

@interface TeamMemberAdd ()

@end

@implementation TeamMemberAdd
{
    NSMutableArray *dataArr;
    User *delUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    [self setExtraCellLineHidden:self.tableView];
    self.title = @"添加球员";
    
    self.tableView.backgroundColor = [GlobalConst appBgColor];
    
    dataArr= [NSMutableArray arrayWithCapacity:10];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSString *searchTerm = searchBar.text;
    
    if(!searchTerm)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"nickname":searchTerm
                                 };
    [dataArr removeAllObjects];
    [self post:@"user/json/search" params:parameters success:^(id responseObj) {
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
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
 

    }];
    
}


-(void)invite:(MyButton*)sender
{
    User *user = (User*)sender.data;
    
    if (!self.team) {
        return;
    }

    NSDictionary *parameters = @{
                                 @"uid":user.uuid,
                                 @"tid":self.team.uuid
                                 };
    //[dataArr removeAllObjects];
    [self post:@"message/json/invite" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
//            NSArray *arr = [dict objectForKey:@"data"];
//            NSError *error = nil;
//            
//            for (NSDictionary *data in arr) {
//                User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
//                if (model!=nil) {
//                    [dataArr addObject:model];
//                }
//            }
//            
//            [self.tableView reloadData];
        }else
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
        }
        
        if([dict objectForKey:@"msg"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        

        
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
    
//    if([dataArr count]==0)
//    {
//        return cell;
//    }
    
    User *entity = [dataArr objectAtIndex:indexPath.row];
    
    if(entity.avatar)
    {
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:entity.avatar]];
        [cell.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
    

    
    cell.txt1.text = entity.nickname;
    cell.txt2.text = entity.position;
    [cell.btn1 setTitle:@"邀请入队" forState:UIControlStateNormal];
    
    
    
    [GlobalUtil addButtonToView:self sender:cell.btn1 action:@selector(invite:) data:entity];
    
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float w = [UIScreen mainScreen].bounds.size.width;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 60)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 15, w-40, 30)];
    
//    for (UIView *view in searchBar.subviews) {
//        // for before iOS7.0
//        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//            [view removeFromSuperview];
//            break;
//        }
//        // for later iOS7.0(include)
//        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
//            [[view.subviews objectAtIndex:0] removeFromSuperview];
//            break;
//        }
//    }


 
    
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

@end
