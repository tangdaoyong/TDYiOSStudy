//
//  UIView+TDYImageScreenShot.m
//  TDYImageTwo
//
//  Created by 唐道勇 on 16/10/12.
//  Copyright © 2016年 唐道勇. All rights reserved.
//
/*
 图片的截屏
 */
#import "UIView+TDYImageScreenShot.h"

@implementation UIView (TDYImageScreenShot)

- (UIImage *) tdy_imageScreenShot{
    
    UIGraphicsBeginImageContext(self.frame.size);//开始
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];//当前的layer图层添加到上下文
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();//从上下文中得到UIimage
    
    UIGraphicsEndImageContext();//结束
    
    return imageNew;
}

@end
