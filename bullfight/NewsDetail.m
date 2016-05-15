//
//  NewsDetail.m
//  bullfight
//
//  Created by goddie on 15/9/15.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "NewsDetail.h"
#import "NewsCommet.h"

@interface NewsDetail ()

@end

@implementation NewsDetail
{
    NSTimer *_timer;    // 用于UIWebView保存图片
    int _gesState;      // 用于UIWebView保存图片
    NSString *_imgURL;  // 用于UIWebView保存图片
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webview.backgroundColor = [UIColor clearColor];
    self.webview.opaque = NO;
    [self.webview setBackgroundColor:[GlobalConst appBgColor]];
    //[self.webview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabBarBg.png"]]];
    
    [self addRightNavButton];
    
    // Do any additional setup after loading the view from its nib.
    [self loadPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}


-(void)addRightNavButton
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0,0,40,30)];
    rightBtn.userInteractionEnabled = YES;
    [rightBtn setTitle:@"评论" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    //[rightBtn setImage:[UIImage imageNamed:@"nav_filter.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    [rightBtn addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
}


-(void)rightPush
{
    NewsCommet *c1 = [[NewsCommet alloc] initWithNibName:@"NewsCommet" bundle:nil];
    c1.aid = self.uuid;
    [self.navigationController pushViewController:c1 animated:YES];
}



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webview stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
}





-(void)loadPage
{
    
    NSString *str = [NSString stringWithFormat:@"%@article/page/newsdetail?uuid=%@",baseURL,self.uuid];
    
    NSString* string2 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string2]];
    [self.webview loadRequest:request];
}

// 功能：UIWebView响应长按事件
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *host=[[request URL].host lowercaseString];if([host hasSuffix:@"itunes.apple.com"])
    {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                   isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            //NSLog(@"you are touching!");
            //NSTimeInterval delaytime = Delaytime;
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                /*
                 @需延时判断是否响应页面内的js...
                 */
                _gesState = GESTURE_STATE_START;
                NSLog(@"touch start!");
                
                float ptX = [[components objectAtIndex:3]floatValue];
                float ptY = [[components objectAtIndex:4]floatValue];
                NSLog(@"touch point (%f, %f)", ptX, ptY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [self.webview stringByEvaluatingJavaScriptFromString:js];
                _imgURL = nil;
                if ([tagName isEqualToString:@"IMG"]) {
                    _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                    
                    
                    //把图片后缀去掉，保存原图
                    //                    NSString *ext =  _imgURL substringToIndex:[_imgURL inde]
                    
                    
                }
                if (_imgURL) {
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
                }
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                _gesState = GESTURE_STATE_MOVE;
                NSLog(@"you are move");
            }
            else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
                [_timer invalidate];
                _timer = nil;
                _gesState = GESTURE_STATE_END;
                NSLog(@"touch end");
            }
        }
        return NO;
    }
    return YES;
}
// 功能：如果点击的是图片，并且按住的时间超过1s，执行handleLongTouch函数，处理图片的保存操作。
- (void)handleLongTouch {
    NSLog(@"%@", _imgURL);
    if (_imgURL && _gesState == GESTURE_STATE_START) {
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存压缩图",@"保存高清图", nil];
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}
// 功能：保存图片到手机
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存压缩图"]) {
        if (_imgURL) {
            NSLog(@"imgurl = %@", _imgURL);
        }
        NSString *urlToSave = [self.webview stringByEvaluatingJavaScriptFromString:_imgURL];
        
        
        
        NSLog(@"image url = %@", urlToSave);
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
        UIImage* image = [UIImage imageWithData:data];
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
        NSLog(@"UIImageWriteToSavedPhotosAlbum = %@", urlToSave);
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    if ([title isEqualToString:@"保存高清图"]) {
        if (_imgURL) {
            NSLog(@"imgurl = %@", _imgURL);
        }
        NSString *urlToSave = [self.webview stringByEvaluatingJavaScriptFromString:_imgURL];
        
        NSString *url =  [self replaceDomain:urlToSave];
        
        NSLog(@"image url = %@", url);
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage* image = [UIImage imageWithData:data];
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
        NSLog(@"UIImageWriteToSavedPhotosAlbum = %@", url);
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
}
// 功能：显示对话框
-(void)showAlert:(NSString *)msg {
    NSLog(@"showAlert = %@", msg);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles: nil];
    [alert show];
}
// 功能：显示图片保存结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error){
        NSLog(@"Error");
        [self showAlert:@"保存失败..."];
    }else {
        NSLog(@"OK");
        [self showAlert:@"保存成功！"];
    }
}



-(NSString*)replaceDomain:(NSString*)str
{
    NSMutableString *tempString = [NSMutableString stringWithString:str];
    
    NSError *error;
    
    NSString *regulaStr = @"_\\d*x\\d*";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:tempString options:0 range:NSMakeRange(0, [tempString length])];
    
    NSString *substringForMatch = [NSString string];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        substringForMatch = [tempString substringWithRange:match.range];
//        NSLog(@"substringForMatch: %@",substringForMatch);
    }
    [tempString replaceOccurrencesOfString:substringForMatch withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [tempString length])];
    
    return tempString;
}


@end
