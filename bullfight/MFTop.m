//
//  MatchFutureTop.m
//  bullfight
//
//  Created by goddie on 15/8/8.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MFTop.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"
#import "TabBarBlue.h"
#import "MyButton.h"

@interface MFTop ()

@end

@implementation MFTop
{
    TabBarBlue *seg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GlobalConst appBgColor];
    // Do any additional setup after loading the view from its nib.
    
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(55.0f, 55.0f)];
    [GlobalUtil setMaskImageQuick:self.img2 withMask:@"round_mask.png" point:CGPointMake(55.0f, 55.0f)];
    

//    [self.seg addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    
    seg = [[TabBarBlue alloc] initWithFrame:CGRectMake(0, 0, 0,0)];
    [seg setTitles:@[@"比赛信息",@"球队数据",@"个人数据",@"赛前动员"]];
    [seg addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    [self.topHolder addSubview:seg];
    
    [self bindData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openTeam1:(MyButton*)sender
{
    
    TIController *c1 = [[TIController alloc] initWithNibName:@"TIController" bundle:nil];
    NSDictionary* dict =(NSDictionary*)sender.data;
    Team *t = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:dict error:nil];
    c1.team = t;
    c1.uuid = t.uuid;
    [self.navigationController pushViewController:c1 animated:YES];
}



-(void)switchView:(id)sender{
    [self.topDelegate changeTab:seg.selectedSegmentIndex];
}


-(void)bindData
{
    if([self.matchFight.host objectForKey:@"avatar"])
    {
        NSString *a1 = [@"" stringByAppendingString:[self.matchFight.host objectForKey:@"avatar"]];
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a1]];
        [self.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
    
    [GlobalUtil addButtonToView:self sender:self.img1  action:@selector(openTeam1:) data:self.matchFight.host];
    

    
    if([self.matchFight.guest objectForKey:@"avatar"])
    {
        NSString *a2 = [@"" stringByAppendingString:[self.matchFight.guest objectForKey:@"avatar"]];
        NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a2]];
        [self.img2 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
    [GlobalUtil addButtonToView:self sender:self.img2  action:@selector(openTeam1:) data:self.matchFight.guest];

    
    self.txtTeam1.text = [self.matchFight.host objectForKey:@"name"];
    self.txtTeam2.text = [self.matchFight.guest objectForKey:@"name"];
    
    self.txtNo1.text = [GlobalUtil toString:self.matchFight.teamSize];
    self.txtNo2.text = [GlobalUtil toString:self.matchFight.teamSize];
    
}



@end
