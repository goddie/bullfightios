//
//  MITop.m
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MITop.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"
#import "MyButton.h"

@interface MITop ()

@end

@implementation MITop
{
    NSMutableArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArr = [NSMutableArray arrayWithCapacity:10];
    
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"round_mask.png" point:CGPointMake(40.0f, 40.0f)];
    [GlobalUtil setMaskImageQuick:self.img2 withMask:@"round_mask.png" point:CGPointMake(40.0f, 40.0f)];
    [GlobalUtil setMaskImageQuick:self.img3 withMask:@"round_mask.png" point:CGPointMake(40.0f, 40.0f)];
    
    [self.seg addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)switchView:(id)sender{
    [self.topDelegate changeTab:self.seg.selectedSegmentIndex];
}


-(void)loadData
{
    NSString *uuid = [LoginUtil getLocalUUID];
    if (!uuid) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uuid,
                                 @"count":@"3"
                                 };

    
    [dataArr removeAllObjects];
    [self post:@"teamuser/json/mytopteam" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
            NSError *error = nil;
            for (NSDictionary *data in arr) {
                Team *model = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:data error:&error];
                if (model!=nil) {
                    [dataArr addObject:model];
                }
            }
            
            [self bindTeam];
        }
    }];

}


-(void)bindTeam
{
    if (dataArr.count==0) {
        return;
    }
    
    
    int w = 40;
    int s = 10;
    
//    int screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    int totalw = 0;
    
    for (int i=0; i<dataArr.count; i++) {
        
        int y = i * w + s*i;
        
        Team *team = [dataArr objectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, w, w)];
        imageView.image = [UIImage imageNamed:@"holder.png"];
        [GlobalUtil setMaskImageQuick:imageView withMask:@"round_mask.png" point:CGPointMake(w, w)];
        
        if (team.avatar) {
            NSURL *imagePath1 = [NSURL URLWithString:[baseURL2 stringByAppendingString:team.avatar]];
            [imageView sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"holder.png"]];
        }
        
        
        [self.teamHolder addSubview:imageView];
        
        [GlobalUtil addButtonToView:self sender:imageView action:@selector(openTeam:) data:team];
        
        
    }
    
//    totalw = ( w + s ) * dataArr.count - s;
//    parent.frame = CGRectMake((self.holder.frame.size.width - totalw)*0.5f, 0, totalw, 40);
//    
//    
//    [self.holder addSubview:parent];

    
    
    
    
}

-(void)openTeam:(MyButton*)sender
{
    Team *t = (Team*)sender.data;

    TIController *c1 = [[TIController alloc] initWithNibName:@"TIController" bundle:nil];
    c1.team = t;
    c1.uuid = t.uuid;
    [self.navigationController pushViewController:c1 animated:YES];
}


@end
