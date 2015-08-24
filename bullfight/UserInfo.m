//
//  UserInfo.m
//  bullfight
//
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

@interface UserInfo ()

@end

@implementation UserInfo
{
    NSArray *titleArr;
    
    NSArray *userArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    titleArr = @[
                @"昵称",
                @"出身日期",
                @"所在地区",
                @"球龄",
                @"身高",
                @"体重",
                @"擅长位置"
                ];
    
    if (self.user) {
        
        userArr = @[
                    [GlobalUtil toString:self.user.username],
                    [GlobalUtil toString:self.user.birthday],
                    [GlobalUtil toString:self.user.city],
                    [GlobalUtil toString:self.user.age],
                    [GlobalUtil toString:self.user.height],
                    [GlobalUtil toString:self.user.weight],
                    [GlobalUtil toString:self.user.position]
                    ];

        
    }
    
    self.title = @"个人资料";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addRightNavButton
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(0,0,26,30)];
    refreshButton.userInteractionEnabled = YES;
    [refreshButton setImage:[UIImage imageNamed:@"nav_filter.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    [refreshButton addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
}


-(void)rightPush
{
    
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
    
    NSIndexPath *pathOne=[NSIndexPath indexPathForRow:row inSection:1];
    TeamFormCell *cell=(TeamFormCell*)[super.tableView cellForRowAtIndexPath:pathOne];
    cell.txt1.text = value;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    
    //UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(200.0f, 200.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(300, 300)];
    
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
    
    [manager POST:[baseURL stringByAppendingString:@""] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(selfPhoto)
                                    name:@"avatar"
                                fileName:@"avatar.png"
                                mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
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
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((w-90)*0.5f, 20, 90, 90)];
    [GlobalUtil setMaskImageQuick:imageView withMask:@"shared_avatar_mask_large.png" point:CGPointMake(90.0f, 90.0f)];
    
    
    if (self.user.avatar) {
        NSURL *imagePath2 = [NSURL URLWithString:[baseURL2 stringByAppendingString:self.user.avatar]];
        [imageView sd_setImageWithURL:imagePath2 placeholderImage:[UIImage imageNamed:@"holder.png"]];
    }
    
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((w-90)*0.5f, imageView.frame.origin.y + imageView.frame.size.height + 20, 90, 24)];
    [GlobalUtil set9PathImage:btn imageName:@"shared_btn_small.png" top:2.0f right:5.0f];
    [btn setTitle:@"更换头像" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    [btn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
    
    [parent addSubview:imageView];
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
