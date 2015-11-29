//
//  CheckUtil.m
//  bullfight
//
//  Created by goddie on 15/10/4.
//  Copyright © 2015年 santao. All rights reserved.
//

#import "CheckUtil.h"

@implementation CheckUtil
-(NSString*) getLocalVer {
    NSDictionary* dict = [[NSBundle mainBundle] infoDictionary];
    return [dict objectForKey:@"CFBundleVersion"];
}


#pragma mark-
#pragma mark- UIAlertViewDelegate
// =============================================================
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 弹出AppStore更新界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" stringByAppendingString:appID]]];
    }
}




#pragma mark-
#pragma mark- NSURLConnectionDelegate
// =============================================================
- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error{
    // 当请求失败时的相关操作；
    NSLog(@"Error info: %@", [error debugDescription]);
}


// =============================================================
-(void) start {
    
    NSError *error;
    NSString* url = [@"http://itunes.apple.com/cn/lookup?id=" stringByAppendingString:appID];
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];

    if (dict) {
        NSArray* results = [dict objectForKey:@"results"];
        if (results && results.count != 0) {
            NSDictionary* resultsDict = [results objectAtIndex:0];
            if (resultsDict) {
                NSString* appstoreVer = [resultsDict objectForKey:@"version"];
                
                if(appstoreVer)
                {
                    float app = [appstoreVer floatValue];
                    float local = [[self getLocalVer] floatValue];
                    
                    if (app == local) {
                        
                        UIAlertView* view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本,是否更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                        
                        [view show];
                        
                    }
                }

            }
        }
    }

}

// =============================================================
+(void) check {
    CheckUtil* checkInst = [[CheckUtil alloc] init];
    [checkInst start];
}
@end
