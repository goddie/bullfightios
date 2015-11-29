//
//  TeamInfoTop.m
//  bullfight
//  球队信息顶部
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TITop.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"
#import "TabBarBlue.h"

@interface TITop ()

@end

@implementation TITop
{
    TabBarBlue *seg;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];

    
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    
    [GlobalUtil setMaskImageQuick:self.img withMask:@"round_mask.png" point:CGPointMake(80.0f, 80.0f)];
    
//    [GlobalUtil addButtonToView:self sender:self.btn1  action:@selector(reminder) data:nil];

//    [self.seg addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    
    seg = [[TabBarBlue alloc] initWithFrame:CGRectMake(0, 0, 0,0)];
    [seg setTitles:@[@"球队战绩",@"球队阵容",@"球队数据",@"获得荣誉"]];
    [seg addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    [self.topHolder addSubview:seg];
    
    self.btn1.hidden=YES;
    
    [self bindData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn1Click:(id)sender {
    NSLog(@"reminder");
    //follow team
}


-(void)switchView:(id)sender{
    [self.topDelegate changeTab:seg.selectedSegmentIndex];
}

-(void)bindData
{
    if (!self.team) {
        return;
    }
    
    if (self.team.avatar) {
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.team.avatar]];
        [self.img sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
    

    
    
    self.txtFound.text = [GlobalUtil getDateFromUNIX:self.team.createdDate];
    self.txtName.text = self.team.name;
    self.txtInfo.text = self.team.info;
}

@end
