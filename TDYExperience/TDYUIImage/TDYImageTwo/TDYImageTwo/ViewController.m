//
//  ViewController.m
//  TDYImageTwo
//
//  Created by 唐道勇 on 16/10/12.
//  Copyright © 2016年 唐道勇. All rights reserved.
//

#import "ViewController.h"
#import "ImageHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self tdy_ImageRotate];//任意角度旋转
    //[self tdy_ImageCut];//图片的剪切
    //[self tdy_ImageCircle];//图片剪切出圆形（其它形状也可以）
    //[self tdy_ImageScale];//图片的拉伸
    //[self tdy_ImageScreen];//屏幕截屏
    //[self tdy_ImageWater];//添加水印图片和文字
}
- (void) tdy_ImageRotate{
    UIImage *myImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"jpg"]];
    UIImage *myRotateImage = [myImage tdy_imageRotateIndegree:45 * M_PI / 180];//输入的角度要是幅度
    UIImageWriteToSavedPhotosAlbum(myRotateImage, nil, nil, nil);//保存到相册
}
- (void) tdy_ImageCut{
    UIImage *myImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"jpg"]];
    UIImage *myRotateImage = [myImage tdy_imageCutSize:CGRectMake(50, 50, 100, 100)];//输入的角度要是幅度
    UIImageWriteToSavedPhotosAlbum(myRotateImage, nil, nil, nil);//保存到相册
}
- (void) tdy_ImageCircle{
    UIImage *myImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"jpg"]];
    UIImage *myRotateImage = [myImage tdy_imageClipCircle];//输入的角度要是幅度
    UIImageWriteToSavedPhotosAlbum(myRotateImage, nil, nil, nil);//保存到相册
}
- (void) tdy_ImageScale{
    UIImage *myImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"jpg"]];
    UIImage *myRotateImage = [myImage tdy_iamgeScaleSize:CGSizeMake(200, 200)];//输入的角度要是幅度
    UIImageWriteToSavedPhotosAlbum(myRotateImage, nil, nil, nil);//保存到相册
}
- (void) tdy_ImageScreen{
    self.view.backgroundColor = [UIColor grayColor];
    UIImage *imageScreen = [self.view tdy_imageScreenShot];
    UIImageWriteToSavedPhotosAlbum(imageScreen, nil, nil, nil);//保存到相册
}
- (void) tdy_ImageWater{
    UIImage *myImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"jpg"]];
    UIImage *myRotateImage = [myImage tdy_imageWater:[UIImage imageNamed:@"5.jpg"] printString:@"这是一段水印文字"];//输入的角度要是幅度
    UIImageWriteToSavedPhotosAlbum(myRotateImage, nil, nil, nil);//保存到相册
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
