//
//  NewsDetail.m
//  bullfight
//
//  Created by goddie on 15/9/15.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "NewsDetail.h"

@interface NewsDetail ()

@end

@implementation NewsDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        [self loadPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}

-(void)loadPage
{
    
    NSString *str = [NSString stringWithFormat:@"%@article/page/newsdetail?uuid=%@",baseURL,self.uuid];
    
    NSString* string2 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string2]];
    [self.webview loadRequest:request];
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
