//
//  TeamBaseInfo.h
//  bullfight
//
//  Created by goddie on 15/8/21.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface TeamCreate : UITableViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) Team *team;
@end
