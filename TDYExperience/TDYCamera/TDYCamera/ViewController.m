//
//  ViewController.m
//  TDYCamera
//
//  Created by 唐道勇 on 16/10/18.
//  Copyright © 2016年 唐道勇. All rights reserved.
//
/*检测camera是否可用*/
#import "ViewController.h"
//导入框架
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //检查相机
    if ([self tdy_isCamera]) {
        NSLog(@"当前相机可用");
    }else{
        NSLog(@"当前相机不可用");
    }
    //检查闪光灯
    if ([self tdy_isCameraFlashAvailRear]) {
        NSLog(@"当前相机后置散光灯可用");
    }else{
        NSLog(@"当前相机后置散光灯不可用");
    }
    if ([self tdy_isCameraFlashAvailFront]) {
        NSLog(@"当前相机前置散光灯可用");
    }else{
        NSLog(@"当前相机前置散光灯不可用");
    }
    //检查摄像头
    if ([self tdy_isCameraAvailRear]) {
        NSLog(@"当前相机后摄像头可用");
    }else{
        NSLog(@"当前相机后摄像头不可用");
    }
    if ([self tdy_isCameraFlashAvailFront]) {
        NSLog(@"当前相机前摄像头可用");
    }else{
        NSLog(@"当前相机前摄像头不灯可用");
    }
    //检查摄像头是否支持拍照和录像
    if ([self tdy_CameraSupprotMedia:(__bridge NSString *)kUTTypeImage]) {
        NSLog(@"摄像头支持拍照");
    }else{
        NSLog(@"摄像头不支持拍照");
    }
    if ([self tdy_CameraSupprotMedia:(__bridge NSString *)kUTTypeMovie]) {
        NSLog(@"摄像头支持摄像");
    }else{
        NSLog(@"摄像头不支持摄像");
    }
}
/*当前相机是否可用*/
- (BOOL)tdy_isCamera{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
/*检测前闪光灯是否可用*/
- (BOOL)tdy_isCameraFlashAvailFront{
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront];
}
/*检测后闪光灯是否可用*/
- (BOOL)tdy_isCameraFlashAvailRear{
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
}
/*检测前摄像头是否可用*/
- (BOOL)tdy_isCameraAvailFront{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
/*检测后摄像头是否可用*/
- (BOOL)tdy_isCameraAvailRear{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
/*摄像头支持的媒体类型，拍照，录像*/
- (BOOL)tdy_CameraSupprotMedia:(NSString *) pareMediaType{
    NSArray *avaiableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    for (NSString *item in avaiableMedia) {
        if ([item isEqualToString:pareMediaType]) {
            return true;
        }
    }
    return false;
}





















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
