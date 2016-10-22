//
//  UIImage+TDYImageCut.m
//  TDYImageTwo
//
//  Created by 唐道勇 on 16/10/12.
//  Copyright © 2016年 唐道勇. All rights reserved.
//

#import "UIImage+TDYImageCut.h"

@implementation UIImage (TDYImageCut)
/*
 步骤：
 1.取
 2.
 3.
 */
- (UIImage *)tdy_imageCutSize:(CGRect) rect{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);//取图片（剪切）
    CGRect smallRect = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));//得到图片的宽高
    
    UIGraphicsBeginImageContext(smallRect.size);//开始绘图
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();//创建上下文
    CGContextDrawImage(contextRef, smallRect, subImageRef);//将上下文中的图片绘制出来
    UIImage *image = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();//结束绘图
    
    return image;
}

@end
