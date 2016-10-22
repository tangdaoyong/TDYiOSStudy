//
//  UIImage+TDYImageRotate.m
//  TDYImageTwo
//
//  Created by 唐道勇 on 16/10/12.
//  Copyright © 2016年 唐道勇. All rights reserved.
//
/*
 UIImage图片的旋转（实际意义上的旋转，不是动画）
 */
#import "UIImage+TDYImageRotate.h"
//- (UIImage *) tdy_imageRotateIndegree:(float) degree;需要引入的头文件（用的vImage）
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (TDYImageRotate)
/*
 步骤：
 1.拿到UIimage图片,转化为变换的上下文Context
 2.context进行改变，变成要求的上下文
 3.将得到的context上下文转换为UIimage图片返回
 */
- (UIImage *) tdy_imageRotateIndegree:(float) degree{
    //1.拿到UIimage图片,转化为变换的上下文Context
    size_t width = (size_t)(self.size.width * self.scale);//图片的宽
    size_t height = (size_t)(self.size.height * self.scale);//图片的高
    size_t bytesPerRow = width * 4;//每行的字节数
    CGImageAlphaInfo alpha = kCGImageAlphaPremultipliedFirst;//alpha通道
    //配置上下文
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault | alpha);//8,表示颜色深度，有八个量级2^8
    if (!bmContext) {//判断上下文，是否配置成功
        return nil;
    }
    CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), self.CGImage);//将图片渲染到上下文中,第3个参数表示要渲染的图片
    //2.context进行改变，变成要求的上下文
    /*
     1.旋转的源图片
     2.旋转之后的图片
     3.
     4.需要旋转的角度
     5.背景颜色
     6.填充颜色
     */
    UInt8 *data = (UInt8*)CGBitmapContextGetData(bmContext);//得到数据
    vImage_Buffer src = {data,height,width,bytesPerRow};//1.数据 2.高 3.宽 4.每行字节数
    
    vImage_Buffer dest = {data,height,width,bytesPerRow};//目标源
    
    Pixel_8888 bgColor = {0, 0, 0, 0};//背景颜色
    vImageRotate_ARGB8888(&src, &dest, NULL, degree, bgColor, kvImageBackgroundColorFill);//这一步就完成了旋转
    //3.将得到的context上下文转换为UIimage图片返回
    CGImageRef rotateImageRef = CGBitmapContextCreateImage(bmContext);//将context转换为CGimage
    UIImage *rotateImage = [UIImage imageWithCGImage:rotateImageRef scale:self.scale orientation:self.imageOrientation];//self.imageOrientation当前图片的方向
    return rotateImage;
}

@end
