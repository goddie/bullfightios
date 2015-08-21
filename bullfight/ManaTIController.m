//
//  ManaTIController.m
//  bullfight
//  我管理的球队
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "ManaTIController.h"
#import "ManaTITop.h"

@interface ManaTIController ()

@end

@implementation ManaTIController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIView*)getTop
{
    ManaTITop *top = [[ManaTITop alloc] initWithNibName:@"ManaTITop" bundle:nil];
    top.team = self.team;
    [self addChildViewController:top];
    return top.view;
}


@end
