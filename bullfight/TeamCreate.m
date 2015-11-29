//
//  TeamBaseInfo.m
//  bullfight
//  球队基本资料
//  Created by goddie on 15/8/21.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "TeamCreate.h"
#import "TeamFormCell.h"
#import "TeamFormInfoCell.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

@interface TeamCreate ()

@end

@implementation TeamCreate
{
    NSArray *titleArr;
    NSArray *cellHeight;
    NSArray *cellName;
    
    
    NSMutableArray *dataArr;
    
    UIImageView *avatarView;
    
    /**
     *  上传成功的头像路径
     */
    NSString *avatarStr;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    titleArr = @[
                @"球队名称",
                @"城市",
                @"成立时间",
                @"球队简介"
                ];
    cellHeight = @[
                   @44.0f,
                   @44.0f,
                   @44.0f,
                   @100.0f
                   ];
    cellName = @[
                 @"TeamFormCell",
                 @"TeamFormCell",
                 @"TeamFormCell",
                 @"TeamFormInfoCell"
                 ];
    
    
    dataArr = [NSMutableArray arrayWithCapacity:10];
    avatarStr = @"";
    
    self.title = @"创建队伍";
    
    
    [self addRightNavButton];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bindData
{
    [dataArr addObject:self.team.name];
    [dataArr addObject:self.team.city];
    [dataArr addObject:[GlobalUtil getDateFromUNIX:self.team.createdDate]];
    [dataArr addObject:self.team.info];
}


-(void)addRightNavButton
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(0,0,30,30)];
    
    [refreshButton setTitle:@"保存" forState:UIControlStateNormal];
    [refreshButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    refreshButton.userInteractionEnabled = YES;
//    [refreshButton setImage:[UIImage imageNamed:@"nav_btn_add.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    [refreshButton addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
    
    
}


-(NSString*)getCellValue:(NSInteger)idx
{
    
    TeamFormCell *cell = (TeamFormCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    //        NSLog(@"%d:%@",idx,cell.txt1.text);
    
    if (!cell.txt1.text) {
        return @"";
    }
    return cell.txt1.text;
}

/**
 *  save team
 */
-(void)rightPush
{
    
    NSString *uid = [LoginUtil getLocalUUID];
    if (!uid) {
        return;
    }
    
    if (![self getCellValue:0]) {
        return;
    }
    
    
    NSDictionary *parameters = @{
                                 @"uid": uid,
                                 @"name": [self getCellValue:0],
                                 @"city": [self getCellValue:1],
                                 @"found":[self getCellValue:2],
                                 @"info":[self getCellValue:3],
                                 @"avatar":avatarStr
                                 };
    
    [self post:@"team/json/create" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [dict objectForKey:@"data"];
            NSError *error;
            Team *model = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:data error:&error];
            
            NSLog(@"%@",[error description]);
            if (model) {
                
                self.team = model;
                
                if ([dict objectForKey:@"msg"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
        
        
        
    }];
}


-(void)headClick
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择图片来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"本地相簿",nil];
    actionSheet.tag = 200;
    [actionSheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 200)
    {
        //NSLog(@"buttonIndex = [%d]",buttonIndex);
        switch (buttonIndex) {
            case 0://照相机
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //			[self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
            case 1://本地相簿
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //			[self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
        
        
    }
    
    
    
    
}


-(void)addDatePicker:(UITextField*)target
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger iCurYear = [components year];  //当前的年份
    
    NSInteger iCurMonth = [components month];  //当前的月份
    
    NSInteger iCurDay = [components day];  // 当前的号数
    
    
    
    NSString *minStr = [NSString stringWithFormat:@"%ld-%ld-%ld 00:00:00",(long)iCurYear,(long)iCurMonth,(long)iCurDay];
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
    
    datePicker.date = minDate;
    
    //        datePicker.minimumDate = minDate;
    //        datePicker.maximumDate = maxDate;
    
    target.inputView = datePicker;
    
    //        [cell.txt1 becomeFirstResponder];
}


#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    
    if ([mediaType isEqualToString:( NSString *)kUTTypeMovie]) {
        //        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        //        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    
    //	[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //	[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}



/**
 *  先创建队伍，再头像
 *
 *  @param image <#image description#>
 */
- (void)saveImage:(UIImage *)image {
    //	NSLog(@"保存头像！");
    //	[userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.png"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    
    //UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(200.0f, 200.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(300, 300)];
    //    [UIImagePNGRepresentation(smallImage) writeToFile:imageFilePath atomically:YES];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //	[userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    //    self.img1.image = selfPhoto;
    
    avatarView.image = selfPhoto;
    
    NSString *tid = @"";
    
    if(self.team)
    {
        tid = self.team.uuid;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"tid": tid
                                 };
    
    [manager POST:[baseURL stringByAppendingString:@"team/json/upavatar"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(selfPhoto)
                                    name:@"file"
                                fileName:@"avatar.jpg"
                                mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [dict objectForKey:@"data"];
            Team *model = [MTLJSONAdapter modelOfClass:[Team class] fromJSONDictionary:data error:nil];
            if (model) {
                
//                self.team = model;
                
                
                avatarStr  = model.avatar;
                if (self.team.avatar) {
                    NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:avatarStr]];
                    [avatarView sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
                }
                
                
//                if ([dict objectForKey:@"msg"]) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
                
            }
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) dateChanged:(UIDatePicker *)sender
{
    UIDatePicker *dataPicker_one = (UIDatePicker *)sender;
    NSDate *date_one = dataPicker_one.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    TeamFormCell *cell = (TeamFormCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.txt1.text = [formatter stringFromDate:date_one];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return titleArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = [[cellHeight objectAtIndex:indexPath.row] intValue];
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [cellName objectAtIndex:indexPath.row];
    
    
    if (indexPath.row==3) {
        TeamFormInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        cell.lab1.text = [titleArr objectAtIndex:indexPath.row];
//        cell.txt1.text = [dataArr objectAtIndex:indexPath.row];
        
        return cell;
    }
    
    TeamFormCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    if (indexPath.row==2) {
        
        [self addDatePicker:cell.txt1];
//        [cell.txt1 setUserInteractionEnabled:NO];
    }
    
    cell.lab1.text = [titleArr objectAtIndex:indexPath.row];
//    cell.txt1.text = [dataArr objectAtIndex:indexPath.row];
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float w = [UIScreen mainScreen].bounds.size.width;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 60)];
    
    
    avatarView = [[UIImageView alloc] initWithFrame:CGRectMake((w-90)*0.5f, 20, 90, 90)];
    [avatarView setImage:[UIImage imageNamed:@"holder.png"]];
    [GlobalUtil setMaskImageQuick:avatarView withMask:@"round_mask.png" point:CGPointMake(90.0f, 90.0f)];
    
    
    if (self.team.avatar) {
        NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.team.avatar]];
        [avatarView sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }

    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((w-120)*0.5f, avatarView.frame.origin.y + avatarView.frame.size.height + 20, 120, 30)];
    [GlobalUtil set9PathImage:btn imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [btn setTitle:@"更换队徽" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    [btn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
    
    [parent addSubview:avatarView];
    [parent addSubview:btn];
    
    return parent;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 220;
}

@end
