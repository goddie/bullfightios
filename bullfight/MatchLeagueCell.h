//
//  MatchWildCell.h
//  bullfight
//
//  Created by goddie on 15/8/10.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchLeagueCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgBot;
@property (weak, nonatomic) IBOutlet UILabel *txtWeather;
@property (weak, nonatomic) IBOutlet UILabel *txtDate;
@property (weak, nonatomic) IBOutlet UILabel *txtPlace;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UILabel *txtTitle;

/**
 *  设置右角标
 *
 *  @param type <#type description#>
 */
-(void)setCorner:(NSInteger)type;

@end
