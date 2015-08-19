//
//  MatchFutureTop.m
//  bullfight
//
//  Created by goddie on 15/8/8.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MFTop.h"

@interface MFTop ()

@end

@implementation MFTop

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GlobalConst appBgColor];
    // Do any additional setup after loading the view from its nib.
    
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(55.0f, 55.0f)];
    [GlobalUtil setMaskImageQuick:self.img2 withMask:@"round_mask.png" point:CGPointMake(55.0f, 55.0f)];
    
    [GlobalUtil addButtonToView:self sender:self.img1  action:@selector(openTeam1) data:nil];
    [GlobalUtil addButtonToView:self sender:self.img2  action:@selector(openTeam1) data:nil];
    [self.seg addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openTeam1
{
    [self.parent openTeam1];
}


-(void)switchView:(id)sender{
    
    [self.parent switchView:sender];
    
}


@end
