//
//  NewsDetail.h
//  bullfight
//
//  Created by goddie on 15/9/15.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetail : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic, strong) NSString *uuid;
@end
