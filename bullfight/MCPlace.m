//
//  MCPlace.m
//  bullfight
//  时间和场地
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MCPlace.h"
#import "MCJudge.h"

@interface MCPlace ()

@end

@implementation MCPlace

- (void)viewDidLoad {
    [super viewDidLoad];
    [GlobalUtil set9PathImage:self.btnNext imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    self.title = @"时间和场地";
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
    MCJudge *c1 = [[MCJudge alloc] initWithNibName:@"MCJudge" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
}
@end
