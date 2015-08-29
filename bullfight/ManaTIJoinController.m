//
//  ManaTIJoinController.m
//  bullfight
//  我加入的球队
//  Created by goddie on 15/8/20.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "ManaTIJoinController.h"
#import "ManaTIJoinTop.h"

@interface ManaTIJoinController ()

@end

@implementation ManaTIJoinController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = self.team.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)getTop
{

    
    
    if(sectionHeader)
    {
        return sectionHeader;
    }
    
    ManaTIJoinTop *top = [[ManaTIJoinTop alloc] initWithNibName:@"ManaTIJoinTop" bundle:nil];
    top.topDelegate = self;
    top.team = self.team;
    [self addChildViewController:top];
    sectionHeader = top.view;
    
    return sectionHeader;
}

@end
