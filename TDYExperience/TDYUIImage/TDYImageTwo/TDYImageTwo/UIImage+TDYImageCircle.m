//
//  UIImage+TDYImageCircle.m
//  TDYImageTwo
//
//  Created by 唐道勇 on 16/10/12.
//  Copyright © 2016年 唐道勇. All rights reserved.
//
/*
 图片剪切园
 取，绘，存
 */
#import "UIImage+TDYImageCircle.h"

@interface view : UIView

@property (nonatomic, retain)UIImage *image;

@end

@implementation view
//UIVIew的属性发生变化的时候都会调用这个方法
- (void) drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();//创建上下文
    CGContextSaveGState(context);//保存状态
    
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, rect.size.width / 2, rect.size.height / 2));//添加弧线
    CGContextClip(context);//裁剪出圆圈
    CGContextFillPath(context);//添加路径
    [self.image drawAtPoint:CGPointMake(0, 0)];//绘制在（0，0）点
    
    CGContextRestoreGState(context);//恢复状态
}
@end

@implementation UIImage (TDYImageCircle)
- (UIImage *) tdy_imageClipCircle{//将UIView转换为UIImage
    CGFloat imageSizeMin = MIN(self.size.width, self.size.height);//
    CGSize imageSize =CGSizeMake(imageSizeMin, imageSizeMin);
    
    view *myView = [[view alloc] init];
    myView.image = self;
    
    UIGraphicsBeginImageContext(imageSize);//开始绘制
    
    CGContextRef context = UIGraphicsGetCurrentContext();//上下文
    myView.frame = CGRectMake(0, 0, imageSizeMin, imageSizeMin);
    myView.backgroundColor = [UIColor blackColor];//设置背景
    
    [myView.layer renderInContext:context];//渲染到上下文
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();//从上下文得到图片
    
    UIGraphicsEndImageContext();//结束绘制
    
    return imageNew;
}

@end
