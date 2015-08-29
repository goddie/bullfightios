//
//  MCPlace.m
//  bullfight
//  时间和场地
//  Created by goddie on 15/8/9.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "MCPlace.h"
#import "MCJudge.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Custome.h"
#import "MCPlaceList.h"

@interface MCPlace ()

@end

@implementation MCPlace

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(selectPlace:) name:@"selectPlace" object:nil];
    
    [self globalConfig];
    [GlobalUtil set9PathImage:self.btnNext imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    self.title = @"时间和场地";
    [self initDate];
    
    
    [GlobalUtil addButtonToView:self sender:self.txtArena action:@selector(arenaClick) data:nil];
    
    [GlobalUtil addButtonToView:self sender:self.txtDate action:@selector(dateClick) data:nil];
    [GlobalUtil addButtonToView:self sender:self.txtStart action:@selector(startClick) data:nil];
    [GlobalUtil addButtonToView:self sender:self.txtEnd action:@selector(endClick) data:nil];
    
    [self getData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)selectPlace:(NSNotification*)notice
{
    NSDictionary *dict = (NSDictionary*)notice.object;

    self.matchFight.arena = dict;
    self.arenaid = [dict objectForKey:@"aid"];
    self.arenaName = [dict objectForKey:@"name"];

    [self bindArena];
}

-(void)initDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger iCurYear = [components year];  //当前的年份
    
    NSInteger iCurMonth = [components month];  //当前的月份
    
    NSInteger iCurDay = [components day];  // 当前的号数
    
    
    
    NSString *minStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)iCurYear,(long)iCurMonth,(long)iCurDay];
    
    self.txtDate.text = minStr;
//    NSString *maxStr = [NSString stringWithFormat:@"%ld-%ld-%d 00:00:00",(long)iCurYear+1,12,31];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    
//    NSDate *minDate = [dateFormatter dateFromString:minStr];
//    NSDate *maxDate = [dateFormatter dateFromString:maxStr];
//    
//    //    NSDate* maxDate = [[NSDate alloc] initWithString:@"2099-01-01 00:00:00 -0500"];
//    
//    
//    UIDatePicker *datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,0.0,0.0,0.0)];
//    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
//    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
//    datePicker.datePickerMode = UIDatePickerModeDate;
//    
//    
//    datePicker.minimumDate = minDate;
//    datePicker.maximumDate = maxDate;
//    
//    self.txtDate.inputView = datePicker;
//    
//    [self.txtDate becomeFirstResponder];

}

-(void)bindArena
{
    if (self.arenaName) {
        self.txtArena.text = self.arenaName;
    }
}

-(void)arenaClick
{
    MCPlaceList *c1 = [[MCPlaceList alloc] initWithNibName:@"MCPlaceList" bundle:nil];
    //self.navigationController.delegate = c1;
    
    [self.navigationController pushViewController:c1 animated:YES];
}

-(void)dateClick
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger iCurYear = [components year];  //当前的年份
    
    NSInteger iCurMonth = [components month];  //当前的月份
    
    NSInteger iCurDay = [components day];  // 当前的号数

 
    
    NSString *minStr = [NSString stringWithFormat:@"%ld-%ld-%d 00:00:00",(long)iCurYear,(long)iCurMonth,1];
    NSString *maxStr = [NSString stringWithFormat:@"%ld-%d-%d 00:00:00",(long)iCurYear+1,12,31];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *minDate = [dateFormatter dateFromString:minStr];
    NSDate *maxDate = [dateFormatter dateFromString:maxStr];
 
//    NSDate* maxDate = [[NSDate alloc] initWithString:@"2099-01-01 00:00:00 -0500"];
    
    
    UIDatePicker *datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,0.0,0.0,0.0)];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    
    self.txtDate.inputView = datePicker;
    
    [self.txtDate becomeFirstResponder];
    
//    [self.view addSubview:datePicker];
    
}

-(void)startClick
{
    UIDatePicker *datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,0.0,0.0,0.0)];
    [datePicker addTarget:self action:@selector(startChanged:) forControlEvents:UIControlEventValueChanged];
     [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.minuteInterval = 5;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
 

    
    self.txtStart.inputView = datePicker;
    
    [self.txtStart becomeFirstResponder];
//    [self.view addSubview:datePicker];
}

-(void)endClick
{
    UIDatePicker *datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,0.0,0.0,0.0)];
    [datePicker addTarget:self action:@selector(endChanged:) forControlEvents:UIControlEventValueChanged];
     [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.minuteInterval = 5;
     self.txtEnd.inputView = datePicker;
    
    [self.txtEnd becomeFirstResponder];
//    [self.view addSubview:datePicker];
}


- (void) dateChanged:(UIDatePicker *)sender
{
    UIDatePicker *dataPicker_one = (UIDatePicker *)sender;
    NSDate *date_one = dataPicker_one.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.txtDate.text = [formatter stringFromDate:date_one];

}


- (void) startChanged:(UIDatePicker *)sender
{
    UIDatePicker *dataPicker_one = (UIDatePicker *)sender;
    NSDate *date_one = dataPicker_one.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    self.txtStart.text = [formatter stringFromDate:date_one];
 
}

- (void) endChanged:(UIDatePicker *)sender
{
    UIDatePicker *dataPicker_one = (UIDatePicker *)sender;
    NSDate *date_one = dataPicker_one.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    self.txtEnd.text = [formatter stringFromDate:date_one];
 
}





- (IBAction)btnNextClick:(id)sender {
    
    

    
    
    
    
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    
    NSString *start =[ NSString stringWithFormat:@"%@ %@:00",self.txtDate.text,self.txtStart.text];
    NSDate *startDate = [formatter_minDate dateFromString:start];
    
    NSString *end =[ NSString stringWithFormat:@"%@ %@:00",self.txtDate.text,self.txtEnd.text];
    NSDate *endDate = [formatter_minDate dateFromString:end];
    
    
    self.matchFight.start = [NSNumber numberWithLongLong:(long long) [startDate timeIntervalSince1970]] ;
    self.matchFight.end = [NSNumber numberWithLongLong:(long long) [endDate timeIntervalSince1970]] ;
    self.matchFight.arena = @{@"aid":self.arenaid};
    
    
    if ([self.matchFight.matchType intValue]==2) {
        
        [self createMatch];
        
        return;
    }
    
    
    MCJudge *c1 = [[MCJudge alloc] initWithNibName:@"MCJudge" bundle:nil];
    
    c1.matchFight = self.matchFight;
    
    [self.navigationController pushViewController:c1 animated:YES];
    
    
}


-(void)createMatch
{

    
    
    NSString *uuid = [LoginUtil getLocalUUID];
    if (!uuid.length) {
        return;
    }
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[self.matchFight.start doubleValue]];
    
    NSString *start =  [formatter stringFromDate:startDate];
    
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[self.matchFight.end doubleValue]];
    NSString *end = [formatter stringFromDate:endDate];
    
   
    
    self.matchFight.judge = [NSNumber numberWithInt:1];
    self.matchFight.dataRecord = [NSNumber numberWithInt:1];
    self.matchFight.teamSize = [NSNumber numberWithInt:5];
    
     NSLog(@"%@",[self.matchFight description]);
    
    NSDictionary *parameters = @{
                                 @"uid":uuid,
                                 @"tid":@"",
                                 @"aid":[self.matchFight.arena objectForKey:@"aid"],
                                 @"matchType":[NSString stringWithFormat:@"%@",self.matchFight.matchType],
                                 @"status":@"1",
                                 @"startStr":start,
                                 @"endStr":end,
                                 @"guestScore":@"0",
                                 @"hostScore":@"0",
                                 @"teamSize":@"5",
                                 @"judge":@"0",
                                 @"dataRecord":@"0",
                                 @"isPay":@"1",
                                 @"fee":@"800"
                                 };
    
    //    MCPay *c1 = [[MCPay alloc] initWithNibName:@"MCPay" bundle:nil];
    //    [self.navigationController pushViewController:c1 animated:YES];
    
    [self post:@"matchfight/json/add" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
        if ([dict objectForKey:@"msg"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[dict objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
    }];

}



-(void)getData
{
    
    NSDictionary *parameters = @{
                                 @"p":@"1"
                                 };
 
    __weak MCPlace *wkSelf = self;
    [self post:@"arena/json/list" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSArray *arr = [dict objectForKey:@"data"];
            NSError *error = nil;
            
            if (arr) {
                NSDictionary *dd = [arr firstObject];
                
                wkSelf.arenaName = [dd objectForKey:@"name"];
                wkSelf.arenaid = [dd objectForKey:@"id"];
                
                [wkSelf bindArena];
            }
            
        }

    }];
    
}















@end
