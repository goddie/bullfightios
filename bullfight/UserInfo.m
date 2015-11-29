//
//  UserInfo.m
//  bullfight
//  基本资料更新
//  Created by goddie on 15/8/22.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "UserInfo.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "TeamFormInfoCell.h"
#import "TeamFormCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface UserInfo ()

@end

@implementation UserInfo
{
    NSArray *titleArr;
    
    NSArray *userArr;
    
    UIImageView *avatarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    titleArr = @[
                @"昵称",
                @"出生日期",
                @"所在地区",
                @"球龄",
                @"身高(cm)",
                @"体重(kg)",
                @"擅长位置"
                ];
    
    
    self.title = @"个人资料";
    
    [self addRightNavButton];
    
}


-(void)bindData
{
    userArr = @[
                [GlobalUtil toString:self.user.nickname],
                [GlobalUtil getDateFromUNIX:self.user.birthday format:@"yyyy-MM-dd"],
                [GlobalUtil toString:self.user.city],
                [GlobalUtil toString:self.user.age],
                [GlobalUtil toString:self.user.height],
                [GlobalUtil toString:self.user.weight],
                [GlobalUtil toString:self.user.position]
                ];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)loadData
{
    NSString *uid = [LoginUtil getLocalUUID];
    if (!uid) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid":uid
                                 };
    [self showHud];
    
    [self post:@"user/json/getuser" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [dict objectForKey:@"data"];
            NSError *error = nil;
            User *entity = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
            
            //NSLog(@"%@",[error description]);
            
            if (entity!=nil) {
                self.user = entity;
                [self bindData];
            }
            
            
        }
        
        [self hideHud];
    }];
}



-(void)viewDidAppear:(BOOL)animated
{
    [self loadData];
}
/**
 *  保存
 */
-(void)addRightNavButton
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [refreshButton setFrame:CGRectMake(0,0,40,30)];
    refreshButton.userInteractionEnabled = YES;
    [refreshButton setTitle:@"保存" forState:UIControlStateNormal];
    
    //[refreshButton setImage:[UIImage imageNamed:@"nav_filter.png"] forState:UIControlStateNormal];
    
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

-(void)rightPush
{
    if (!self.user) {
        
        [[AppDelegate delegate] loginPage];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid": self.user.uuid,
                                 @"nickname": [self getCellValue:0],
                                 @"birthday": [self getCellValue:1],
                                 @"city":[self getCellValue:2],
                                 @"age":[self getCellValue:3],
                                 @"height":[self getCellValue:4],
                                 @"weight":[self getCellValue:5],
                                 @"position":[self getCellValue:6]
                                 };
    

    
    
    
    [self post:@"user/json/update" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [dict objectForKey:@"data"];
            NSError *error;
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
            
            NSLog(@"%@",[error description]);
            if (model) {
                
                self.user = model;
                
                if ([dict objectForKey:@"msg"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                [self.view endEditing:YES];
                
            }
            
            
        }

        
        
        
        
    }];
    
    
}

-(void)changeAvatar
{

}


-(void)posClick
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择位置"
                                  delegate:self
                                  cancelButtonTitle:@"关闭"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"控球后卫", @"得分后卫",@"小前锋",@"大前锋",@"中锋",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

-(void)headClick
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择图片来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍摄",@"从相册选择",nil];
    actionSheet.tag = 200;
    [actionSheet showInView:self.view];
}


-(UITableViewCell*)getCellFromTableView:(UITableView*)tableView sender:(id)sender
{
    CGPoint pos = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:pos];
    return [tableView cellForRowAtIndexPath:indexPath];
}


-(void)setTableForm:(NSString*)value row:(NSInteger)row
{
    TeamFormCell *cell = (TeamFormCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
//    NSIndexPath *pathOne=[NSIndexPath indexPathForRow:row inSection:1];
//    TeamFormCell *cell=(TeamFormCell*)[super.tableView cellForRowAtIndexPath:pathOne];
    cell.txt1.text = value;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 100) {
        if (buttonIndex==5) {
            return;
        }
        
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        [self setTableForm:title row:6];
        
        
    }
    
    
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
    
    
    if(!self.user.uuid)
    {
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"uid": self.user.uuid
                                 };
    
    [manager POST:[baseURL stringByAppendingString:@"user/json/upavatar"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(selfPhoto)
                                    name:@"file"
                                fileName:@"avatar.jpg"
                                mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [dict objectForKey:@"data"];
            User *model = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];
            if (model) {
                
                self.user = model;
                if (self.user.avatar) {
                    NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.user.avatar]];
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
    
    TeamFormCell *cell = (TeamFormCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
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
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"TeamFormCell";

    
    TeamFormCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    cell.txt1.text = [userArr objectAtIndex:indexPath.row];
    
    cell.lab1.text = [titleArr objectAtIndex: indexPath.row];
    
    if (indexPath.row==1) {
        
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
        
        cell.txt1.inputView = datePicker;
        
//        [cell.txt1 becomeFirstResponder];
        

    }
    
    
    if(indexPath.row==6)
    {
        [cell.txt1 setUserInteractionEnabled:NO];
        
        
    }
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float w = [UIScreen mainScreen].bounds.size.width;
    
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 60)];
    
    
    avatarView = [[UIImageView alloc] initWithFrame:CGRectMake((w-90)*0.5f, 20, 90, 90)];
    [GlobalUtil setMaskImageQuick:avatarView withMask:@"shared_avatar_mask_large.png" point:CGPointMake(90.0f, 90.0f)];
    
    
    if (self.user.avatar) {
        NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.user.avatar]];
        [avatarView sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
    
    [GlobalUtil addButtonToView:self sender:avatarView action:@selector(headClick) data:nil];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((w-90)*0.5f, avatarView.frame.origin.y + avatarView.frame.size.height + 20, 90, 24)];
    [GlobalUtil set9PathImage:btn imageName:@"shared_btn_small.png" top:2.0f right:5.0f];
    [btn setTitle:@"更换头像" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    [btn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
    
    [parent addSubview:avatarView];
    [parent addSubview:btn];
    
    parent.backgroundColor = [GlobalConst appBgColor];
    
    return parent;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 220;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==6) {
        [self posClick];
    }
   
}


@end
