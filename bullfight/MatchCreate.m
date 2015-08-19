//
//  MatchCreate.m
//  bullfight
//
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MatchCreate.h"
#import "MCTeam.h"

@interface MatchCreate ()

@end

@implementation MatchCreate

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [GlobalConst appBgColor];
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




- (IBAction)btnFreeClick:(id)sender {
    
    MCTeam *c1 = [[MCTeam alloc] initWithNibName:@"MCTeam" bundle:nil];
    [self.navigationController pushViewController:c1 animated:YES];
    
}

- (IBAction)btnTeamClick:(id)sender {
    
    
    
}

- (IBAction)btnCloseClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


@end
