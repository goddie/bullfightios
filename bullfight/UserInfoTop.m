//
//  METop.m
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "UserInfoTop.h"
#import "UIImageView+WebCache.h"
#import "TabBarBlue.h"
#import "MyButton.h"

@interface UserInfoTop ()

@end

@implementation UserInfoTop
{
    TabBarBlue *seg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GlobalConst appBgColor];
    // Do any additional setup after loading the view from its nib.
    
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(55.0f, 55.0f)];
    [GlobalUtil setMaskImageQuick:self.img2 withMask:@"round_mask.png" point:CGPointMake(55.0f, 55.0f)];
    
    [GlobalUtil addButtonToView:self sender:self.img1  action:@selector(openTeam1:) data:self.matchFight.host];
    [GlobalUtil addButtonToView:self sender:self.img2  action:@selector(openTeam1:) data:self.matchFight.guest];
//    [self.seg addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    
    
    seg = [[TabBarBlue alloc] initWithFrame:CGRectMake(0, 0, 0,0)];
    [seg setTitles:@[@"个人数据"]];
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
 
}

-(void)bindData
{
    if([self.matchFight.host objectForKey:@"avatar"])
    {
        NSString *a1 = [GlobalUtil toString:[self.matchFight.host objectForKey:@"avatar"]];
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a1]];
        [self.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
    
    
    if([self.matchFight.guest objectForKey:@"avatar"])
    {
        NSString *a2 = [GlobalUtil toString:[self.matchFight.guest objectForKey:@"avatar"]];
        NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a2]];
        [self.img2 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
    
    
    
    self.txtTeam1.text = [self.matchFight.host objectForKey:@"name"];
    self.txtTeam2.text = [self.matchFight.guest objectForKey:@"name"];
    
    self.txtNo1.text = [GlobalUtil toString:self.matchFight.teamSize];
    self.txtNo2.text = [GlobalUtil toString:self.matchFight.teamSize];
    
    self.txtScore.text = [NSString stringWithFormat:@"%@:%@",[GlobalUtil toString:self.matchFight.hostScore],[GlobalUtil toString:self.matchFight.guestScore]];
    
}


@end
