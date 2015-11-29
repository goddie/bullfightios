//
//  UserInfo.h
//  bullfight
//
//  Created by goddie on 15/8/22.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserInfo : UITableViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) User *user;

@end
