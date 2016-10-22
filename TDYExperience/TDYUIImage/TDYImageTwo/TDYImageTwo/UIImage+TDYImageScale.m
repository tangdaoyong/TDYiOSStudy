//
//  UIImage+TDYImageScale.m
//  TDYImageTwo
//
//  Created by 唐道勇 on 16/10/12.
//  Copyright © 2016年 唐道勇. All rights reserved.
//
/*
 图片的缩放
 */
#import "UIImage+TDYImageScale.h"

@implementation UIImage (TDYImageScale)

- (UIImage *) tdy_iamgeScaleSize:(CGSize) size{
    UIGraphicsBeginImageContext(size);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();//从当前的上下文中获取图片
    
    UIGraphicsEndImageContext();
    return imageNew;
}

@end
