//
//  MCJudge.m
//  bullfight
//  裁判和数据员
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MCJudge.h"
#import "MCPay.h"

@interface MCJudge ()

@end

@implementation MCJudge

- (void)viewDidLoad {
    [super viewDidLoad];
    [GlobalUtil set9PathImage:self.btnNext imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    self.title = @"裁判和数据员";
    
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

- (IBAction)btnNextClick:(id)sender {
    MCPay *c1 = [[MCPay alloc] initWithNibName:@"MCPay" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
}
@end
