//
//  MatchCreate.m
//  bullfight
//  创建比赛
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchCreate.h"
#import "MCTeam.h"
#import "MatchFight.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"
#import "MCPlace.h"
#import "MCTeamWild.h"

@interface MatchCreate ()

@end

@implementation MatchCreate

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.hidesBottomBarWhenPushed=YES;
    [self globalConfig];
    
    self.title = @"创建比赛";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//野球娱乐
- (IBAction)btnFreeClick:(id)sender {
    
    MatchFight *matchFight = [MatchFight new];
    matchFight.matchType = [NSNumber numberWithInt:2];
    
    
    MCPlace *c1 = [[MCPlace alloc] initWithNibName:@"MCPlace" bundle:nil];
    c1.matchFight = matchFight;
    c1.isFree = YES;
    [self.navigationController pushViewController:c1 animated:YES];
    
//    MCTeam *c1 = [[MCTeam alloc] initWithNibName:@"MCTeam" bundle:nil];
//    c1.matchFight = matchFight;
////    c1.isFree = YES;
//    [self.navigationController pushViewController:c1 animated:YES];
    
}

//团队
- (IBAction)btnTeamClick:(id)sender {
    
    MatchFight *matchFight = [MatchFight new];
    matchFight.matchType = [NSNumber numberWithInt:1];
    
    
    MCTeam *c1 = [[MCTeam alloc] initWithNibName:@"MCTeam" bundle:nil];
    c1.matchFight = matchFight;
    [self.navigationController pushViewController:c1 animated:YES];
    
}

- (IBAction)btnCloseClick:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    
}


@end
