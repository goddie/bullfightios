//
//  MITop.m
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MITop.h"

@interface MITop ()

@end

@implementation MITop

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(40.0f, 40.0f)];
    [GlobalUtil setMaskImageQuick:self.img2 withMask:@"round_mask.png" point:CGPointMake(40.0f, 40.0f)];
    [GlobalUtil setMaskImageQuick:self.img3 withMask:@"round_mask.png" point:CGPointMake(40.0f, 40.0f)];
    
    [self.seg addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)switchView:(id)sender{
    [self.topDelegate changeTab:self.seg.selectedSegmentIndex];
}

@end
