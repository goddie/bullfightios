//
//  TeamInfoTop.m
//  bullfight
//
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TITop.h"

@interface TITop ()

@end

@implementation TITop

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [GlobalConst appBgColor];
    
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    
    [GlobalUtil setMaskImageQuick:self.img withMask:@"round_mask.png" point:CGPointMake(80.0f, 80.0f)];
    
    [GlobalUtil addButtonToView:self sender:self.btn1  action:@selector(reminder) data:nil];

    [self.seg addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    
    
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

- (IBAction)btn1Click:(id)sender {
}


-(void)reminder
{
    [self.parent reminder];
}


-(void)switchView:(id)sender{
    
    [self.parent switchView:sender];
    
}
@end
