//
//  ViewController.m
//  TDYUIImage
//
//  Created by 唐道勇 on 16/10/10.
//  Copyright © 2016年 唐道勇. All rights reserved.
//
/*
 1.图片的格式：jpg , git, webp(新型的，体积缩减了)
 */
#import "ViewController.h"
#import <UIImage+GIF.h>
//gif图片进行分解需要用到的两个头文件
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
//图片类型枚举
typedef NS_ENUM(NSInteger, imageType) {
    imageTypeOne,
    imageTypeTwo,
    imageTypeThere
};
/*
 注意事项：
 1.scale 图片size = 手机size *scale 手机主屏幕的Scale[UIScreen mainScreen].scale 2@X和3@x的由来
 2.图片的缓存。[UIImage imageNamed:@"name"];加载的图片，是存在缓存中的，下次加载时，直接从缓存中拿（快）。[[NSBundle mainBundle] pathForResource:@"name" ofType:@"jgp"];用完之后，图片是从缓存中清除了的。
 3.UIimageView如果UIimageView比较小，而图片比较大，我们可以先将图片缩放，在加载，也可以节省空间。
 */
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self tdy_addImageToPhotoAlbumName:@"1"];
    //[self tdy_showImageName:nil];
    //[self tdy_jpgToPng];
    //[self tdy_pngTpJpg];
    //[self tdy_gifImageDeCompsition];
    //[self tdy_playGIFImageInSDWebImage];
}
/*
 iOS 10 增加了新的安全设定。 如果要访问相机 相册 麦克风需要在 info.plist 内增加条目
 根据控制台的提示，我们需要在plist文件添加相应的字段
 相机权限
 添加key字段NSCameraUsageDescription，string类型，value字段是给用户的提示文字，例如“我们需要使用您的相机“
 通信录
 NSContactsUsageDescription
 麦克风
 NSMicrophoneUsageDescription
 相册
 NSPhotoLibraryUsageDescription
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -image操作的方法
/*
 获取.bundle文件中的图片文件
 */
- (UIImage *) tdy_getImageFromeBundle:(NSString *) bundleName imageName:(NSString *) imageName imageType:(imageType) imageType{
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:bundleName];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    //具有返回值得black方法
    UIImage *(^getBundleImage)(NSString *) = ^(NSString *n) {
        NSString *imageTypeString = @"jpg";
        switch (imageType) {
            case imageTypeOne:
                imageTypeString = @"jpg";
                break;
            case imageTypeTwo:
                imageTypeString = @"png";
                break;
            case imageTypeThere:
                imageTypeString = @"gif";
                break;
            default:
                break;
        }
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:n ofType:imageTypeString]];
    };
    return getBundleImage(imageName);
}
/*
 UIImageView展示GIF图片(需要得到gif图片数组)
 */
- (void) tdy_UIImageViewShowGifImageArray:(NSArray *) imageArray{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:imageView];
    
    [imageView setAnimationImages:imageArray];
    [imageView setAnimationRepeatCount:2];//播放次数
    [imageView setAnimationDuration:2];//周期
    [imageView startAnimating];
}
/**
 *  SDWebImageView播放
 */
- (void) tdy_playGIFImageInSDWebImage{
    UIImageView *GIFImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    GIFImageView.contentMode = UIViewContentModeScaleAspectFill;
    GIFImageView.backgroundColor = [UIColor blueColor];
    UIImage *gifImage = [UIImage sd_animatedGIFNamed:@"3"];//由于此方法的实现是在[NSBundle mainBundle]中直接查找图片，所以不能显示放在.bundle中的gif图片。（已经修改了SDWebImageView中sd_animatedGIFNamed：方法的源码，现在已经可以直接使用了，但qi其它地方使用这个方法可能出现问题）
    GIFImageView.image = gifImage;
    [self.view addSubview:GIFImageView];
    /*
     //tdy添加start(在sd_animatedGIFNamed:中修改的内容)
     NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"image.bundle"];
     NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
     NSString *retinaPath = [bundle pathForResource:name ofType:@"gif"];//bundle中没有@2X图片，只能写name
     //tdy end
     */
}
/*
 gif图片的分解
 #import <ImageIO/ImageIO.h>
 #import <MobileCoreServices/MobileCoreServices.h>
 步骤：
 1.我们要拿到gif的数据
 2.将gif图片分解为一帧帧的图片
 3.将单帧的图片转化为UIimage
 4.单帧图片的保存
 */
- (void) tdy_gifImageDeCompsition{
    //1.我们要拿到gif的数据
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"image.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *gifPathSource = [bundle pathForResource:@"3" ofType:@"gif"];//拿到gif图片的路径
    NSData *data = [NSData dataWithContentsOfFile:gifPathSource];//拿到data数据
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);//将data数据转化为CGImageSourceRef数据，(__bridge CFDataRef)为桥接
    //2.将gif图片分解为一帧帧的图片
    size_t count = CGImageSourceGetCount(source);//得到一共有多少帧
    NSMutableArray *imageArray = @[].mutableCopy;
    for(int i = 0; i < count; i++){
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);//得到单帧的数据
        //将单帧的数据转换为UIImage
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];//scale表示手机像素与物理像素的映射关系，[UIScreen mainScreen].scale直接获得手机的映射关系。
        [imageArray addObject:image];//释放缓存前先保存图片
        
        CGImageRelease(imageRef);//将缓存释放掉
    }
    CFRelease(source);//也将source的缓存释放掉
    //4.单帧图片的保存
    NSLog(@"%@", NSHomeDirectory());//打印沙盒路径
    //[self tdy_UIImageViewShowGifImageArray:imageArray];//用UIimageView展示gif图片
    [self tdy_imagesToGIFImage:imageArray];//合成gif
    int i = 0;
    for (UIImage *image in imageArray) {
        NSData *data = UIImagePNGRepresentation(image);//将image类型的数据转化为data类型的数据
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *pathGif = path[0];//得到了当前沙盒中Document目录
        NSString *pathName = [pathGif stringByAppendingString:[NSString stringWithFormat:@"%d.png", i]];//组合图片名称
        [data writeToFile:pathName atomically:NO];//写到目录下
        i++;
    }
}
/*
 合成gif图片
 1.获取图片数据
 2.创建GIF图片
 3.配置gif图片属性
 4.单帧图片添加到gif中
 */
- (void) tdy_imagesToGIFImage:(NSArray *) imagesArray{
    //1.获取图片数据
    NSMutableArray *imageArray = @[].mutableCopy;
    for (int i = 0; i < imagesArray.count; i++) {
        if (i < 5) {
            [imageArray addObject:imagesArray[i]];
        }else{
            break;
        }
    }
    //2.创建GIF图片
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentString = documentPath[0];
    NSFileManager *fileManager = [NSFileManager defaultManager];//文件管理
    NSString *textDic = [documentString stringByAppendingString:@"/gif"];//创建文件夹路径
    [fileManager createDirectoryAtPath:textDic withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
    NSString *path = [textDic stringByAppendingString:@"test.gif"];
    NSLog(@"path = %@", path);
    //3.配置gif图片属性
    CGImageDestinationRef destion;
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)path, kCFURLPOSIXPathStyle, false);//将path映射为CFURLRef格式的url
    destion = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imageArray.count, NULL);
    NSDictionary *frameDic = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.3], (NSString *)kCGImagePropertyGIFDelayTime, nil] forKey: (NSString *)kCGImagePropertyGIFDelayTime];
    
    NSMutableDictionary *gifParmdict = [NSMutableDictionary dictionaryWithCapacity:2];
    [gifParmdict setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCGImagePropertyGIFHasGlobalColorMap];//设置颜色
    [gifParmdict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];//设置颜色
    [gifParmdict setObject:[NSNumber numberWithInt:8] forKey:(NSString *)kCGImagePropertyDepth];//设置颜色深度
    [gifParmdict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];//设置是否可以重复
    NSDictionary *preperty = [NSDictionary dictionaryWithObject:gifParmdict forKey:(NSString *)kCGImagePropertyGIFDictionary];//设置为prepertyDic
    //4.单帧图片添加到gif中
    for (UIImage *image in imageArray) {
        CGImageDestinationAddImage(destion, image.CGImage, (__bridge CFDictionaryRef)frameDic);//帧图片添加（添加到对象中）
    }
    CGImageDestinationSetProperties(destion, (__bridge CFDictionaryRef)preperty);
    CGImageDestinationFinalize(destion);//完成初始化
    //CFRelease(destion);//清理掉
}
/*
 图片的转换：jpg转为png
 */
- (void) tdy_jpgToPng{
    UIImage *imagejpg = [self tdy_getImageFromeBundle:@"image.bundle" imageName:@"2" imageType:imageTypeOne];
    NSData *data = UIImagePNGRepresentation(imagejpg);//转为png不用传质量因子，因为png是无损的且可以设置透明，而jpg是有损的。
    UIImage *imagePNG = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(imagePNG, nil, nil, nil);
}
/*
 图片的转换：png转为jpg
 */
- (void) tdy_pngTpJpg{
    UIImage *imagePNG = [self tdy_getImageFromeBundle:@"image.bundle" imageName:@"1" imageType:imageTypeTwo];
    NSData *data = UIImageJPEGRepresentation(imagePNG, 1);//第二个因素为质量因子，1~1之间，越大质量越高，占用的内存越大。
    UIImage *imagejpg = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(imagejpg, nil, nil, nil);
}
/*
 显示一张图片，image要放到一个容器中才能显示，imageView等
 */
- (void) tdy_showImageName:( NSString * _Nonnull) imageName{
    UIImage *photoImage = [self tdy_getImageFromeBundle:@"image.bundle" imageName:imageName imageType:imageTypeTwo];
    //设置UIImageView
    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    photoImageView.center = self.view.center;
    [self.view addSubview:photoImageView];
    photoImageView.image = photoImage;
}
/*
 保存图片到相册
 */
- (void) tdy_addImageToPhotoAlbumName:(nonnull NSString *) imageName{
    //.bundle打包的图片要用一下的方式取得
    UIImage *photoImage = [self tdy_getImageFromeBundle:@"image.bundle" imageName:imageName imageType:imageTypeTwo];
    //UIImage *photoImage = [UIImage imageNamed:imageName];
    UIImageWriteToSavedPhotosAlbum(photoImage, nil, nil, nil);//保存图片到相册(不宜过大，以免程序崩溃)
    //UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    /*
     有时候你的应用需要将应用中的图片保存到用户iPhone或者iTouch的相册中。 可以使用UIKit的这个类方法来完成。
     void UIImageWriteToSavedPhotosAlbum (
         UIImage  *image,
         id       completionTarget,
         SEL      completionSelector,
         void     *contextInfo
     );
     image:要保存到用户设备中的图片
     completionTarget:当保存完成后，回调方法所在的对象
     completionSelector:当保存完成后，所调用的回调方法。 形式如下：
     - (void) image: (UIImage *) image
     didFinishSavingWithError: (NSError *) error
     contextInfo: (void *) contextInfo;
     contextInfo:可选的参数，保存了一个指向context数据的指针，它将传递给回调方法。
     比如你可以这样来写一个存贮照片的方法：
     // 要保存的图片
     UIImage *img = [UIImage imageNamed:@"ImageName.png"];
     // 保存图片到相册中
     UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
     回调方法看起来可能是这样：
     - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
     contextInfo:(void *)contextInfo
     {
     // Was there an error?
     if (error != NULL)
     {
     // Show error message...
     
     }
     else  // No errors
     {
     // Show message image successfully saved
     }
     }
     */
}


@end
