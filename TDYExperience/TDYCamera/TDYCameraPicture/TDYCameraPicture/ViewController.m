//
//  ViewController.m
//  TDYCameraPicture
//
//  Created by 唐道勇 on 16/10/18.
//  Copyright © 2016年 唐道勇. All rights reserved.
//
/*拍照，显示，保存，从相册中选择*/
#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>//扫描相片库需要（ios4~ios8）
#import <Photos/Photos.h>//ios8之后用的photosframework
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *myImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"进入viewDidLoad");
    // Do any additional setup after loading the view, typically from a nib.
    //扫描相册，显示第一张图片
    [self tdy_cameraPhoto];
    //1.检测当前相机是否可用
    //2.配置UIImagePickerController
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(tdy_configImagePickController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //[self tdy_configImagePickController];
}
/*扫描相片库,并将第一张图片显示出来*/
- (void) tdy_cameraPhoto{
    //1.lib
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];//ios9中已经被弃用，要寻找新的，photosframework(http://www.jianshu.com/p/5fa2e4ca8fd3)
    //2.创建子线程
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//创建一个队列
    dispatch_async(q, ^{
        NSLog(@"线程 = %@", [NSThread currentThread]);
        //扫描媒体库
        [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            //扫描成功
            //使用一个black查看我们遍历的资源(有几个相册进入这里几次)
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                //主要业务逻辑
                //__block BOOL myBool = false;
                NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                if ([assetType isEqualToString:ALAssetTypePhoto]) {//如果是图片
                    *stop = true;//找到了第一张图片之后，停止在这个相册查找了。
                    ALAssetRepresentation *assetRepresentation = [result defaultRepresentation];
                    CGFloat imageScale = [assetRepresentation scale];//缩放系数
                    UIImageOrientation imageOrientaion= (UIImageOrientation)[assetRepresentation orientation];
                    //回到主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CGImageRef imageRef = [assetRepresentation fullResolutionImage];
                        //UIImage *image = [UIImage imageWithCGImage:imageRef];
                        UIImage *image = [[UIImage alloc] initWithCGImage:imageRef scale:imageScale orientation:imageOrientaion];
                        if (image != nil) {
                            //myBool = true;
                            self.myImage.image = image;
                            static int numberThere = 0;
                            NSLog(@"number =======!!!!!!!!!========== %d", numberThere++);
                        }
                    });
                    static int numberTwo = 0;
                    NSLog(@"number ====================== %d", numberTwo++);
                }
                //*stop = myBool;
                static int number = 0;
                NSLog(@"number ！！！！！！！！！！！！！！= %d", number++);
            }];
            static int numberOne = 0;
            NSLog(@"number @@@@@@= %d", numberOne++);
        } failureBlock:^(NSError *error) {
            NSLog(@"扫描媒体库失败：%@", error);
        }];
    });
}
/*照相并保存*/
- (void)tdy_configImagePickController{
    UIImagePickerController *myController = [[UIImagePickerController alloc] init];
    myController.sourceType = UIImagePickerControllerSourceTypeCamera;//以camera作为我们的源（可以从相册中选择）
    NSString *requireType = (__bridge NSString *)kUTTypeImage;
    myController.mediaTypes = [[NSArray alloc] initWithObjects:requireType, nil];//初始化类型
    myController.allowsEditing = false;//是否可以编辑
    myController.delegate = self;//设置代理
    myController.cameraDevice = UIImagePickerControllerCameraDeviceRear;//配置后置摄像头
    myController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;//闪光灯的配置
    
    [self presentViewController:myController animated:YES completion:^{
        NSLog(@"100");
    }];
}
#pragma mark -Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    NSLog(@"1");
}
//拍照完成后的回调方法
//info可以拿到1.媒体信息2.image3.媒体的附加数据
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"11");
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];//通过info,拿到媒体类型
    if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]) {//类型是图片
        UIImage *tdyImage = [info objectForKey:UIImagePickerControllerOriginalImage];//拿到原始图片
        self.myImage.contentMode = UIViewContentModeScaleToFill;
        self.myImage.image = tdyImage;
        //图片的保存
        //SEL saveImage = @selector(tdy_savaImage:didFinishSavingWrithError:contextInfo:);
        //UIImageWriteToSavedPhotosAlbum(tdyImage, self, saveImage, nil);
        NSDictionary *dict = [info objectForKey:UIImagePickerControllerMediaMetadata];
        NSLog(@"唐道勇 dict = %@", dict);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];//退出
}
//保存图片的方法后调用的方法
- (void)tdy_savaImage:(UIImage *)image didFinishSavingWrithError:(NSError *) savaError contextInfo:(void *)paraInfo{
    if (savaError == nil) {
        NSLog(@"图片保存成功");
    }else{
        NSLog(@"图片保存失败，error = %@", savaError);
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"111");
    //cancel的回调
    [super dismissViewControllerAnimated:YES completion:nil];
}














- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
