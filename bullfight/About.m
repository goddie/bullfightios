//
//  About.m
//  bullfight
//
//  Created by goddie on 15/9/1.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "About.h"
#import "UIViewController+Custome.h"

@interface About ()

@end

@implementation About

- (void)viewDidLoad {
    [super viewDidLoad];
    [self globalConfig];
    
    self.title = @"关于来斗牛";
    
    
    [self loadPage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadPage
{
    
    NSString *str = [baseURL stringByAppendingString:@"article/page/detail?title=关于来斗牛"];
    
    NSString* string2 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string2]];
    [self.webView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
