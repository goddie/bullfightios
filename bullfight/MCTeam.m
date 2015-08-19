//
//  MCTeam.m
//  bullfight
//  球队和比赛形式
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MCTeam.h"
#import "MCPlace.h"

@interface MCTeam ()

@end

@implementation MCTeam

- (void)viewDidLoad {
    [super viewDidLoad];
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(110.0f, 110.0f)];
    [GlobalUtil set9PathImage:self.btnNext imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    self.title = @"球队和比赛形式";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnNextClick:(id)sender {
    
    MCPlace *c1 = [[MCPlace alloc] initWithNibName:@"MCPlace" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
}
@end
