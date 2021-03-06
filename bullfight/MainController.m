//
//  MainController.m
//  Bullfight
//
//  Created by goddie on 15/6/14.
//  Copyright (c) 2015年 goddie. All rights reserved.
//

#import "MainController.h"
#import "NotReady.h"
#import "MatchTeam.h"
#import "My.h"
#import "LoginUtil.h"
#import "NewsList.h"
#import "PlayerList.h"
#import "CheckUtil.h"


@interface MainController ()

@end

@implementation MainController
{
     NSString *trackViewUrl;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSThread sleepForTimeInterval:1.0f];

    
//    TopTabController *c1= [[TopTabController alloc] initWithNibName:@"TopTabController" bundle:nil];
//    
//    TeamFightController *teamFightController = [[TeamFightController alloc] initWithNibName:@"TeamFightController" bundle:nil];
//    WildFightController *wildFightController = [[WildFightController alloc] initWithNibName:@"WildFightController" bundle:nil];
//    
//    [c1 setButtons:@[@"团队约战",@"野球娱乐"] vcs:@[teamFightController,wildFightController] activeIndex:0];
    
    MatchTeam *c1 = [[MatchTeam alloc] initWithNibName:@"MatchTeam" bundle:nil];
    UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:c1];
    nav1.tabBarItem.title=@"比赛";
    nav1.tabBarItem.image=[UIImage imageNamed:@"tab_icon_match_active.png"];
    //nav1.tabBarItem.badgeValue=@"99";
    
    
//    GateController *c2=[[GateController alloc] initWithNibName:@"GateController" bundle:nil];
    NewsList *c2 = [[NewsList alloc] initWithNibName:@"NewsList" bundle:nil];
    
    
    //NotReady *c2 = [[NotReady alloc] initWithNibName:@"NotReady" bundle:nil];
    UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:c2];
    nav2.tabBarItem.title=@"新闻";
    nav2.tabBarItem.image=[UIImage imageNamed:@"tab_icon_news_active.png"];
    
//    RegSMSController *c3=[[RegSMSController alloc] initWithNibName:@"RegSMSController" bundle:nil];
    //QRootElement *root = [RegController create];
    //RegController *c3 = (RegController *) [[RegController alloc] initWithRoot:root];
    PlayerList *c3 = [[PlayerList alloc] initWithNibName:@"PlayerList" bundle:nil];
    UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:c3];
    nav3.tabBarItem.title=@"牛丸圈";
    nav3.tabBarItem.image=[UIImage imageNamed:@"tab_icon_activities_active.png"];
    
//    UserHomeController *c4=[[UserHomeController alloc] initWithNibName:@"UserHomeController" bundle:nil];
    My *c4 = [[My alloc] initWithNibName:@"My" bundle:nil];
    
    c4.userId = [LoginUtil getLocalUUID];
    
    UINavigationController* nav4 = [[UINavigationController alloc] initWithRootViewController:c4];
    nav4.tabBarItem.title=@"我";
    nav4.tabBarItem.image=[UIImage imageNamed:@"tab_icon_profile_active.png"];
    
    
    //c.添加子控制器到ITabBarController中
    //c.1第一种方式
    //    [tb addChildViewController:c1];
    //    [tb addChildViewController:c2];
    
    //c.2第二种方式
    self.viewControllers=@[nav1,nav2,nav3,nav4];
    UITabBar* tabBar = [UITabBar appearance];
    
    tabBar.translucent = NO;
    tabBar.tintColor = [GlobalConst tabTintColor];
    tabBar.backgroundColor = [GlobalConst tabBgColor];
    tabBar.barTintColor = [GlobalConst tabBgColor];
    
    
    UINavigationBar* navigationBar =  [UINavigationBar appearance];
    //self.extendedLayoutIncludesOpaqueBars = YES;
    navigationBar.translucent = NO;
    navigationBar.barTintColor = [GlobalConst tabBgColor];
    navigationBar.tintColor = [GlobalConst tabTintColor];
    
    NSDictionary *dict = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    navigationBar.titleTextAttributes = dict;
    
    
    [self checkUpdate];
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 弹出AppStore更新界面
        
        NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/lai-dou-niu/id1015790236?l=zh&ls=1&mt=8"];
        //NSString *url =[ NSString stringWithFormat:@"itms-services://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@",appID ];
        //NSString *url = [NSString stringWithFormat:@"%@page/appstore.jsp",baseURL];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}


// =============================================================
-(void) checkUpdate {
    
    NSError *error;
    NSString* url = [@"http://itunes.apple.com/cn/lookup?id=" stringByAppendingString:appID];
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if (dict) {
        NSArray* results = [dict objectForKey:@"results"];
        if (results && results.count != 0) {
            NSDictionary* resultsDict = [results objectAtIndex:0];
            if (resultsDict) {
                NSString* appstoreVer = [resultsDict objectForKey:@"version"];
                trackViewUrl = [resultsDict objectForKey:@"trackViewUrl"];
                
                if(appstoreVer)
                {
                    float app = [appstoreVer floatValue];
                    float local = [[self getLocalVer] floatValue];
                    
                    if (app > local) {
                        
                        UIAlertView* view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本,是否更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                        
                        [view show];
                        
                    }
                }
                
            }
        }
    }
    
}

-(NSString*) getLocalVer {
    NSDictionary* dict = [[NSBundle mainBundle] infoDictionary];
    return [dict objectForKey:@"CFBundleVersion"];
}


@end
