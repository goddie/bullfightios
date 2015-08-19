//
//  RegTwo.m
//  bullfight
//
//  Created by goddie on 15/8/18.
//  Copyright (c) 2015年 santao. All rights reserved.
//

#import "RegThree.h"
#import "AppDelegate.h"
#import "UIViewController+Custome.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface RegThree ()

@end

@implementation RegThree

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalConfig];
    
    self.title = @"注册";
    
    //    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{ NSForegroundColorAttributeName : [UIColor redColor] }];
    //    self.txt1.attributedPlaceholder = str;
    
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"请输入所在城市" attributes:@{ NSForegroundColorAttributeName : [GlobalConst lightAppBgColor] }];
    self.txt2.attributedPlaceholder = str2;
    
    [GlobalUtil addButtonToView:self sender:self.img1 action:@selector(headClick) data:0];
    [GlobalUtil set9PathImage:self.btn1 imageName:@"shared_big_btn.png" top:2.0f right:5.0f];
    [GlobalUtil setMaskImageQuick:self.img1 withMask:@"shared_avatar_mask_small.png" point:CGPointMake(70.0f, 80.0f)];
    [GlobalUtil addButtonToView:self sender:self.lab1 action:@selector(posClick) data:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                                  otherButtonTitles:@"照相机",@"本地相簿",nil];
    actionSheet.tag = 200;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 100) {
        if (buttonIndex==5) {
            return;
        }
        
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        self.lab1.text = title;
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


- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

- (IBAction)btn1Click:(id)sender {
    
    NSString *uid = [LoginUtil getLocalUUID];
    if(uid.length==0)
    {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"position":self.lab1.text,
                                 @"city":self.txt2.text,
                                 @"uid":uid
                                 };
    
    
    [self post:@"user/json/regthree" params:parameters success:^(id responseObj) {
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            //            RegTwo *c1 = [[RegTwo alloc] initWithNibName:@"RegTwo" bundle:nil];
            //            [self.navigationController pushViewController:c1 animated:YES];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        [[AppDelegate delegate] changeRoot];
        
    }];

    
    
}

- (IBAction)btn2Click:(id)sender {
    [[AppDelegate delegate] changeRoot];
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
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(200, 200)];
    
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //	[userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    self.img1.image = selfPhoto;
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


//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//NSString *documentsDirectory = [paths objectAtIndex:0];
//NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
//NSLog(@"imageFile->>%@",imageFilePath);
//UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//
//self.img.image = selfPhoto;
//[self.img.layer setCornerRadius:CGRectGetHeight([self.img bounds]) / 2];  //修改半径，实现头像的圆形化
//self.img.layer.masksToBounds = YES;



@end
