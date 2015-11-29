//
//  TabBarBlue.m
//  bullfight
//
//  Created by goddie on 15/9/3.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TabBarBlue.h"

@implementation TabBarBlue
{
    NSInteger height;
    NSArray *titles;
    NSMutableArray *buttons;
    UIImageView *hotBg;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        buttons = [NSMutableArray arrayWithCapacity:4];
        height = 32;
        
        float w = [UIScreen mainScreen].bounds.size.width;
        
        self.frame = CGRectMake(0, 0, w, height);
        
        //背景图
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, height)];
        
//        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, height)];
//        UIImage *bgImg = [UIImage imageNamed:@"tabbarblue_bg.png"];
        
//        [bg setClipsToBounds:YES];
//        bg.contentMode = UIViewContentModeBottom;
        
        [GlobalUtil set9PathImage:bg imageName:@"tabbarblue_bg.png" top:2.0f right:2.0f];
        
//        [bg setImage:[UIImage imageNamed:@"tabbarblue_bg.png"]];
//        bg.backgroundColor = [UIColor redColor];
        [self addSubview:bg];
        
    

        
        
    }
    return self;
}


-(void)setTitles:(NSArray*)titleArr
{
    

    
    titles = titleArr;
    
    float btnWidth = self.frame.size.width / 4.0f;
    float parentWidth = btnWidth*titles.count;
    
    
    
    UIView *btnParent = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - parentWidth)*0.5f, 0, parentWidth, height)];
    
    hotBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 115.0f, height)];
    [hotBg setImage:[UIImage imageNamed:@"tab_center.png"]];
    [btnParent addSubview:hotBg];
    
    
    for (int i=0; i<titles.count; i++) {
        
        float x = i*btnWidth;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, btnWidth, height)];
        [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [btn.titleLabel setTextColor:[GlobalConst lightAppBgColor]];
        [btn setTag:i+10];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        
        [buttons addObject:btn];
        [btnParent addSubview:btn];
        
    }
    
    

    
//    btnParent.backgroundColor = [UIColor yellowColor];
    [self addSubview:btnParent];
    
    [self setActive:0];
}


-(void)btnClick:(id)sender
{
    UIButton *btn  = (UIButton*)sender;
    
    NSInteger idx = btn.tag - 10;
    
    self.selectedSegmentIndex = idx;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    [self setActive:idx];
}

/**
 *  设置某按钮激活
 *
 *  @param idx <#idx description#>
 */
-(void)setActive:(NSInteger)idx
{
    self.selectedSegmentIndex = idx;
    
   
    UIButton *hotBtn = [buttons objectAtIndex:idx];
    
    //按钮中心点x坐标
    float x = hotBtn.frame.origin.x + hotBtn.frame.size.width * 0.5f;
    
    //激活图x坐标
    float x2 = x - hotBg.frame.size.width *0.5f;
    
    hotBg.frame = CGRectMake(x2, 0, hotBg.frame.size.width, height);
}



@end
