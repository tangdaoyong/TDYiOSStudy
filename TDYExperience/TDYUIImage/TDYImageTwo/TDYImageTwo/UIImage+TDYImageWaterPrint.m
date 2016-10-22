//
//  UIImage+TDYImageWaterPrint.m
//  TDYImageTwo
//
//  Created by 唐道勇 on 16/10/12.
//  Copyright © 2016年 唐道勇. All rights reserved.
//
/*
 给图片添加水印，和logo
 */
#import "UIImage+TDYImageWaterPrint.h"

@implementation UIImage (TDYImageWaterPrint)
- (UIImage *) tdy_imageWater:(UIImage *) imageLogo printString:(NSString *) waterString{
    UIGraphicsBeginImageContext(self.size);
    //原始图片渲染
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //渲染imageLoge
    CGFloat waterX = self.size.width - imageLogo.size.width;
    CGFloat waterY = self.size.height - imageLogo.size.height;
    CGFloat waterW = imageLogo.size.width;
    CGFloat waterH = imageLogo.size.height;
    [imageLogo drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];//渲染imageLoge
    //渲染文中
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor redColor]};
    [waterString drawInRect:CGRectMake(0, 0, 300, 40) withAttributes:dic];
    //得到UIImage
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return imageNew;
}

@end
