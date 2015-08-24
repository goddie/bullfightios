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
    
    [self bindData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openTeam1
{
    //[self.parent openTeam1];
}



-(void)switchView:(id)sender{
    [self.topDelegate changeTab:self.seg.selectedSegmentIndex];
}


-(void)bindData
{
    if([self.matchFight.host objectForKey:@"avatar"])
    {
        NSString *a1 = [@"" stringByAppendingString:[self.matchFight.host objectForKey:@"avatar"]];
        NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a1]];
        [self.img1 sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }

    
    if([self.matchFight.guest objectForKey:@"avatar"])
    {
        NSString *a2 = [@"" stringByAppendingString:[self.matchFight.guest objectForKey:@"avatar"]];
        NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:a2]];
        [self.img2 sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
    

    
    self.txtTeam1.text = [self.matchFight.host objectForKey:@"name"];
    self.txtTeam2.text = [self.matchFight.guest objectForKey:@"name"];
    
    self.txtNo1.text = [GlobalUtil toString:self.matchFight.teamSize];
    self.txtNo2.text = [GlobalUtil toString:self.matchFight.teamSize];
    
}



@end
