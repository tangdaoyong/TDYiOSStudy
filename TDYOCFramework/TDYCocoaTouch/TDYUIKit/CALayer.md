#CALayer（ios核心动画）
[参考链接](http://www.cnblogs.com/kenshincui/p/3972100.html)
在iOS中随处都可以看到绚丽的动画效果，实现这些动画的过程并不复杂，今天将带大家一窥iOS动画全貌。在这里你可以看到iOS中如何使用图层精简非交互式绘图，如何通过核心动画创建基础动画、关键帧动画、动画组、转场动画，如何通过UIView的装饰方法对这些动画操作进行简化等。在今天的文章里您可以看到动画操作在iOS中是如何简单和高效，很多原来想做但是苦于没有思路的动画在iOS中将变得越发简单：
###CALayer
#####CALayer介绍
在介绍动画操作之前我们必须先来了解一个动画中常用的对象CALayer。CALayer包含在QuartzCore框架中，这是一个跨平台的框架，既可以用在iOS中又可以用在Mac OS X中。在使用Core Animation开发动画的本质就是将CALayer中的内容转化为位图从而供硬件操作，所以要熟练掌握动画操作必须先来熟悉CALayer。
在上一篇文章中使用Quartz 2D绘图时大家其实已经用到了CALayer，当利用drawRect:方法绘图的本质就是绘制到了UIView的layer（属性）中，可是这个过程大家在上一节中根本体会不到。但是在Core Animation中我们操作更多的则不再是UIView而是直接面对CALayer。下图描绘了CALayer和UIView的关系，在UIView中有一个layer属性作为根图层，根图层上可以放其他子图层，在UIView中所有能够看到的内容都包含在layer中：
![](/Users/tangdaoyong/Desktop/Objective-C/TDYOCFramework/TDYCocoaTouch/TDYUIKit/150628367066332.png)
#####CALayer常用属性
在iOS中CALayer的设计主要是了为了内容展示和动画操作，CALayer本身并不包含在UIKit中，它不能响应事件。由于CALayer在设计之初就考虑它的动画操作功能，CALayer很多属性在修改时都能形成动画效果，这种属性称为“隐式动画属性”。但是对于UIView的根图层而言属性的修改并不形成动画效果，因为很多情况下根图层更多的充当容器的做用，如果它的属性变动形成动画效果会直接影响子图层。另外，UIView的根图层创建工作完全由iOS负责完成，无法重新创建，但是可以往根图层中添加子图层或移除子图层。

下表列出了CALayer常用的属性：

    属性	说明	是否支持隐式动画
    anchorPoint	和中心点position重合的一个点，称为“锚点”，锚点的描述是相对于x、y位置比例而言的默认在图像中心点(0.5,0.5)的位置	是
    backgroundColor	图层背景颜色	是
    borderColor	边框颜色	是
    borderWidth	边框宽度	是
    bounds	图层大小	是
    contents	图层显示内容，例如可以将图片作为图层内容显示	是
    contentsRect	图层显示内容的大小和位置	是
    cornerRadius	圆角半径	是
    doubleSided	图层背面是否显示，默认为YES	否
    frame	图层大小和位置，不支持隐式动画，所以CALayer中很少使用frame，通常使用bounds和position代替	否
    hidden	是否隐藏	是
    mask	图层蒙版	是
    maskToBounds	子图层是否剪切图层边界，默认为NO	是
    opacity	透明度 ，类似于UIView的alpha	是
    position	图层中心点位置，类似于UIView的center	是
    shadowColor	阴影颜色	是
    shadowOffset	阴影偏移量	是
    shadowOpacity	阴影透明度，注意默认为0，如果设置阴影必须设置此属性	是
    shadowPath	阴影的形状	是
    shadowRadius	阴影模糊半径	是
    sublayers	子图层	是
    sublayerTransform	子图层形变	是
    transform	图层形变
隐式属性动画的本质是这些属性的变动默认隐含了CABasicAnimation动画实现，详情大家可以参照Xcode帮助文档中“Animatable Properties”一节。
在CALayer中很少使用frame属性，因为frame本身不支持动画效果，通常使用bounds和position代替。
CALayer中透明度使用opacity表示而不是alpha；中心点使用position表示而不是center。
anchorPoint属性是图层的锚点，范围在（0~1,0~1）表示在x、y轴的比例，这个点永远可以同position（中心点）重合，当图层中心点固定后，调整anchorPoint即可达到调整图层显示位置的作用（因为它永远和position重合）
    为了进一步说明anchorPoint的作用，假设有一个层大小100*100，现在中心点位置（50,50），由此可以得出frame（0,0,100,100）。上面说过anchorPoint默认为（0.5,0.5），同中心点position重合，此时使用图形描述如图1；当修改anchorPoint为（0,0），此时锚点处于图层左上角，但是中心点poition并不会改变，因此图层会向右下角移动，如图2；然后修改anchorPoint为（1,1,），position还是保持位置不变，锚点处于图层右下角，此时图层如图3。
![](/Users/tangdaoyong/Desktop/Objective-C/TDYOCFramework/TDYCocoaTouch/TDYUIKit/150628373935488.png)
下面通过一个简单的例子演示一下上面几个属性，程序初始化阶段我们定义一个正方形，但是圆角路径调整为正方形边长的一般，使其看起来是一个圆形，在点击屏幕的时候修改图层的属性形成动画效果（注意在程序中没有直接修改UIView的layer属性，因为根图层无法形成动画效果）：

    #import "KCMainViewController.h"
    #define WIDTH 50

    @interface KCMainViewController ()

    @end

    @implementation KCMainViewController

    - (void)viewDidLoad {
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        [self drawMyLayer];
    }

    #pragma mark 绘制图层
    -(void)drawMyLayer{
        CGSize size=[UIScreen mainScreen].bounds.size;

        //获得根图层
        CALayer *layer=[[CALayer alloc]init];
        //设置背景颜色,由于QuartzCore是跨平台框架，无法直接使用UIColor
        layer.backgroundColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
        //设置中心点
        layer.position=CGPointMake(size.width/2, size.height/2);
        //设置大小
        layer.bounds=CGRectMake(0, 0, WIDTH,WIDTH);
        //设置圆角,当圆角半径等于矩形的一半时看起来就是一个圆形
        layer.cornerRadius=WIDTH/2;
        //设置阴影
        layer.shadowColor=[UIColor grayColor].CGColor;
        layer.shadowOffset=CGSizeMake(2, 2);
        layer.shadowOpacity=.9;
        //设置边框
    //    layer.borderColor=[UIColor whiteColor].CGColor;
    //    layer.borderWidth=1;

        //设置锚点
    //    layer.anchorPoint=CGPointZero;

        [self.view.layer addSublayer:layer];

    }

    #pragma mark 点击放大
    -(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
        UITouch *touch=[touches anyObject];
        CALayer *layer=self.view.layer.sublayers[0];
        CGFloat width=layer.bounds.size.width;
        if (width==WIDTH) {
            width=WIDTH*4;
        }else{
            width=WIDTH;
        }
        layer.bounds=CGRectMake(0, 0, width, width);
        layer.position=[touch locationInView:self.view];
        layer.cornerRadius=width/2;
    }
    @end

#####CALayer绘图
上一篇文章中重点讨论了使用Quartz 2D绘图，当时调用了UIView的drawRect:方法绘制图形、图像，这种方式本质还是在图层中绘制，但是这里会着重介绍一下如何直接在图层中绘图。在图层中绘图的方式跟原来基本没有区别，只是drawRect:方法是由UIKit组件进行调用，因此里面可以使用一些UIKit封装的方法进行绘图，而直接绘制到图层的方法由于并非UIKit直接调用因此只能用原生的Core Graphics方法绘制。

图层绘图有两种方法，不管使用哪种方法绘制完必须调用图层的setNeedDisplay方法（注意是图层的方法，不是UIView的方法，前面我们介绍过UIView也有此方法）

通过图层代理drawLayer: inContext:方法绘制
通过自定义图层drawInContext:方法绘制
使用代理方法绘图

通过代理方法进行图层绘图只要指定图层的代理，然后在代理对象中重写-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx方法即可。需要注意这个方法虽然是代理方法但是不用手动实现CALayerDelegate，因为CALayer定义中给NSObject做了分类扩展，所有的NSObject都包含这个方法。另外设置完代理后必须要调用图层的setNeedDisplay方法，否则绘制的内容无法显示。

下面的代码演示了在一个自定义图层绘制一张图像并将图像设置成圆形，这种效果在很多应用中很常见，如最新版的手机QQ头像就是这种效果：

    #import "KCMainViewController.h"
    #define PHOTO_HEIGHT 150

    @interface KCMainViewController ()

    @end

    @implementation KCMainViewController

    - (void)viewDidLoad {
        [super viewDidLoad];

        //自定义图层
        CALayer *layer=[[CALayer alloc]init];
        layer.bounds=CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
        layer.position=CGPointMake(160, 200);
        layer.backgroundColor=[UIColor redColor].CGColor;
        layer.cornerRadius=PHOTO_HEIGHT/2;
        //注意仅仅设置圆角，对于图形而言可以正常显示，但是对于图层中绘制的图片无法正确显示
        //如果想要正确显示则必须设置masksToBounds=YES，剪切子图层
        layer.masksToBounds=YES;
        //阴影效果无法和masksToBounds同时使用，因为masksToBounds的目的就是剪切外边框，
        //而阴影效果刚好在外边框
    //    layer.shadowColor=[UIColor grayColor].CGColor;
    //    layer.shadowOffset=CGSizeMake(2, 2);
    //    layer.shadowOpacity=1;
        //设置边框
        layer.borderColor=[UIColor whiteColor].CGColor;
        layer.borderWidth=2;

        //设置图层代理
        layer.delegate=self;

        //添加图层到根图层
        [self.view.layer addSublayer:layer];

        //调用图层setNeedDisplay,否则代理方法不会被调用
        [layer setNeedsDisplay];
    }

    #pragma mark 绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
    -(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    //    NSLog(@"%@",layer);//这个图层正是上面定义的图层
        CGContextSaveGState(ctx);

        //图形上下文形变，解决图片倒立的问题
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);

        UIImage *image=[UIImage imageNamed:@"photo.png"];
        //注意这个位置是相对于图层而言的不是屏幕
        CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);

    //    CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
    //    CGContextDrawPath(ctx, kCGPathFillStroke);

        CGContextRestoreGState(ctx);
    }

    @end
使用代理方法绘制图形、图像时在drawLayer:inContext:方法中可以通过事件参数获得绘制的图层和图形上下文。在这个方法中绘图时所有的位置都是相对于图层而言的，图形上下文指的也是当前图层的图形上下文。

需要注意的是上面代码中绘制图片圆形裁切效果时如果不设置masksToBounds是无法显示圆形，但是对于其他图形却没有这个限制。原因就是当绘制一张图片到图层上的时候会重新创建一个图层添加到当前图层，这样一来如果设置了圆角之后虽然底图层有圆角效果，但是子图层还是矩形，只有设置了masksToBounds为YES让子图层按底图层剪切才能显示圆角效果。同样的，有些朋友经常在网上提问说为什么使用UIImageView的layer设置圆角后图片无法显示圆角，只有设置masksToBounds才能出现效果，也是类似的问题。

扩展1--带阴影效果的圆形图片裁切

如果设置了masksToBounds=YES之后确实可以显示图片圆角效果，但遗憾的是设置了这个属性之后就无法设置阴影效果。因为masksToBounds=YES就意味着外边框不能显示，而阴影恰恰作为外边框绘制的，这样两个设置就产生了矛盾。要解决这个问题不妨换个思路:使用两个大小一样的图层，下面的图层负责绘制阴影，上面的图层用来显示图片。

    #import "KCMainViewController.h"
    #define PHOTO_HEIGHT 150

    @interface KCMainViewController ()

    @end

    @implementation KCMainViewController

    - (void)viewDidLoad {
        [super viewDidLoad];

        CGPoint position= CGPointMake(160, 200);
        CGRect bounds=CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
        CGFloat cornerRadius=PHOTO_HEIGHT/2;
        CGFloat borderWidth=2;

        //阴影图层
        CALayer *layerShadow=[[CALayer alloc]init];
        layerShadow.bounds=bounds;
        layerShadow.position=position;
        layerShadow.cornerRadius=cornerRadius;
        layerShadow.shadowColor=[UIColor grayColor].CGColor;
        layerShadow.shadowOffset=CGSizeMake(2, 1);
        layerShadow.shadowOpacity=1;
        layerShadow.borderColor=[UIColor whiteColor].CGColor;
        layerShadow.borderWidth=borderWidth;
        [self.view.layer addSublayer:layerShadow];

        //容器图层
        CALayer *layer=[[CALayer alloc]init];
        layer.bounds=bounds;
        layer.position=position;
        layer.backgroundColor=[UIColor redColor].CGColor;
        layer.cornerRadius=cornerRadius;
        layer.masksToBounds=YES;
        layer.borderColor=[UIColor whiteColor].CGColor;
        layer.borderWidth=borderWidth;

        //设置图层代理
        layer.delegate=self;

        //添加图层到根图层
        [self.view.layer addSublayer:layer];

        //调用图层setNeedDisplay,否则代理方法不会被调用
        [layer setNeedsDisplay];
    }

    #pragma mark 绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
    -(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
        //    NSLog(@"%@",layer);//这个图层正是上面定义的图层
        CGContextSaveGState(ctx);

        //图形上下文形变，解决图片倒立的问题
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);

        UIImage *image=[UIImage imageNamed:@"photo.jpg"];
        //注意这个位置是相对于图层而言的不是屏幕
        CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);

        //    CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
        //    CGContextDrawPath(ctx, kCGPathFillStroke);

        CGContextRestoreGState(ctx);
    }
    @end
扩展2--图层的形变

从上面代码中大家不难发现使用Core Graphics绘制图片时会倒立显示，对图层的图形上下文进行了反转。在前一篇文章中也采用了类似的方法去解决这个问题，但是在那篇文章中也提到过如果直接让图像沿着x轴旋转180度同样可以达到正确显示的目的，只是当时的旋转靠图形上下文还无法绕x轴旋转。今天学习了图层之后，其实可以控制图层直接旋转而不用借助于图形上下文的形变操作，而且这么操作起来会更加简单和直观。对于上面的程序，只需要设置图层的transform属性即可。需要注意的是transform是CATransform3D类型，形变可以在三个维度上进行，使用方法和前面介绍的二维形变是类似的，而且都有对应的形变设置方法（如：CATransform3DMakeTranslation()、CATransform3DMakeScale()、CATransform3DMakeRotation()）。下面的代码通过CATransform3DMakeRotation()方法在x轴旋转180度解决倒立问题：

    #import "KCMainViewController.h"
    #define PHOTO_HEIGHT 150

    @interface KCMainViewController ()

    @end

    @implementation KCMainViewController

    - (void)viewDidLoad {
        [super viewDidLoad];

        CGPoint position= CGPointMake(160, 200);
        CGRect bounds=CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
        CGFloat cornerRadius=PHOTO_HEIGHT/2;
        CGFloat borderWidth=2;

        //阴影图层
        CALayer *layerShadow=[[CALayer alloc]init];
        layerShadow.bounds=bounds;
        layerShadow.position=position;
        layerShadow.cornerRadius=cornerRadius;
        layerShadow.shadowColor=[UIColor grayColor].CGColor;
        layerShadow.shadowOffset=CGSizeMake(2, 1);
        layerShadow.shadowOpacity=1;
        layerShadow.borderColor=[UIColor whiteColor].CGColor;
        layerShadow.borderWidth=borderWidth;
        [self.view.layer addSublayer:layerShadow];

        //容器图层
        CALayer *layer=[[CALayer alloc]init];
        layer.bounds=bounds;
        layer.position=position;
        layer.backgroundColor=[UIColor redColor].CGColor;
        layer.cornerRadius=cornerRadius;
        layer.masksToBounds=YES;
        layer.borderColor=[UIColor whiteColor].CGColor;
        layer.borderWidth=borderWidth;

        //利用图层形变解决图像倒立问题
        layer.transform=CATransform3DMakeRotation(M_PI, 1, 0, 0);

        //设置图层代理
        layer.delegate=self;

        //添加图层到根图层
        [self.view.layer addSublayer:layer];

        //调用图层setNeedDisplay,否则代理方法不会被调用
        [layer setNeedsDisplay];
    }

    #pragma mark 绘制图形、图像到图层，注意参数中的ctx时图层的图形上下文，其中绘图位置也是相对图层而言的
    -(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
        //    NSLog(@"%@",layer);//这个图层正是上面定义的图层
        UIImage *image=[UIImage imageNamed:@"photo.jpg"];
        //注意这个位置是相对于图层而言的不是屏幕
        CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
    }

    @end
事实上如果仅仅就显示一张图片在图层中当然没有必要那么麻烦，直接设置图层contents就可以了，不牵涉到绘图也就没有倒立的问题了。

    //
    //  图层内容设置
    //  CALayer
    //
    //  Created by Kenshin Cui on 14-3-22.
    //  Copyright (c) 2014年 Kenshin Cui. All rights reserved.
    //

    #import "KCMainViewController.h"
    #define PHOTO_HEIGHT 150

    @interface KCMainViewController ()

    @end

    @implementation KCMainViewController

    - (void)viewDidLoad {
        [super viewDidLoad];

        CGPoint position= CGPointMake(160, 200);
        CGRect bounds=CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
        CGFloat cornerRadius=PHOTO_HEIGHT/2;
        CGFloat borderWidth=2;

        //阴影图层
        CALayer *layerShadow=[[CALayer alloc]init];
        layerShadow.bounds=bounds;
        layerShadow.position=position;
        layerShadow.cornerRadius=cornerRadius;
        layerShadow.shadowColor=[UIColor grayColor].CGColor;
        layerShadow.shadowOffset=CGSizeMake(2, 1);
        layerShadow.shadowOpacity=1;
        layerShadow.borderColor=[UIColor whiteColor].CGColor;
        layerShadow.borderWidth=borderWidth;
        [self.view.layer addSublayer:layerShadow];

        //容器图层
        CALayer *layer=[[CALayer alloc]init];
        layer.bounds=bounds;
        layer.position=position;
        layer.backgroundColor=[UIColor redColor].CGColor;
        layer.cornerRadius=cornerRadius;
        layer.masksToBounds=YES;
        layer.borderColor=[UIColor whiteColor].CGColor;
        layer.borderWidth=borderWidth;
        //设置内容（注意这里一定要转换为CGImage）
        UIImage *image=[UIImage imageNamed:@"photo.jpg"];
    //    layer.contents=(id)image.CGImage;
        [layer setContents:(id)image.CGImage];

        //添加图层到根图层
        [self.view.layer addSublayer:layer];
    }

    @end
既然如此为什么还大费周章的说形变呢，因为形变对于动画有特殊的意义。在动画开发中形变往往不是直接设置transform，而是通过keyPath进行设置。这种方法设置形变的本质和前面没有区别，只是利用了KVC可以动态修改其属性值而已，但是这种方式在动画中确实很常用的，因为它可以很方便的将几种形变组合到一起使用。同样是解决动画旋转问题，只要将前面的旋转代码改为下面的代码即可：

[layer setValue:@M_PI forKeyPath:@"transform.rotation.x"];
当然，通过key path设置形变参数就需要了解有哪些key path可以设置，这里就不再一一列举，大家可以参照Xcode帮助文档中“CATransform3D Key Paths”一节，里面描述的很详细。

使用自定义图层绘图

在自定义图层中绘图时只要自己编写一个类继承于CALayer然后在drawInContext:中绘图即可。同前面在代理方法绘图一样，要显示图层中绘制的内容也要调用图层的setNeedDisplay方法，否则drawInContext方法将不会调用。

前面的文章中曾经说过，在使用Quartz 2D在UIView中绘制图形的本质也是绘制到图层中，为了说明这个问题下面演示自定义图层绘图时没有直接在视图控制器中调用自定义图层，而是在一个UIView将自定义图层添加到UIView的根图层中（例子中的UIView跟自定义图层绘图没有直接关系）。从下面的代码中可以看到：UIView在显示时其根图层会自动创建一个CGContextRef（CALayer本质使用的是位图上下文），同时调用图层代理（UIView创建图层会自动设置图层代理为其自身）的draw: inContext:方法并将图形上下文作为参数传递给这个方法。而在UIView的draw:inContext:方法中会调用其drawRect:方法，在drawRect:方法中使用UIGraphicsGetCurrentContext()方法得到的上下文正是前面创建的上下文。

    KCLayer.m

    //
    //  KCLayer.m
    //  CALayer
    //
    //  Created by Kenshin Cui on 14-3-22.
    //  Copyright (c) 2014年 Kenshin Cui. All rights reserved.
    //

    #import "KCLayer.h"

    @implementation KCLayer

    -(void)drawInContext:(CGContextRef)ctx{
        NSLog(@"3-drawInContext:");
        NSLog(@"CGContext:%@",ctx);
    //    CGContextRotateCTM(ctx, M_PI_4);
        CGContextSetRGBFillColor(ctx, 135.0/255.0, 232.0/255.0, 84.0/255.0, 1);
        CGContextSetRGBStrokeColor(ctx, 135.0/255.0, 232.0/255.0, 84.0/255.0, 1);
    //    CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
    //    CGContextFillEllipseInRect(ctx, CGRectMake(50, 50, 100, 100));
        CGContextMoveToPoint(ctx, 94.5, 33.5);

        //// Star Drawing
        CGContextAddLineToPoint(ctx,104.02, 47.39);
        CGContextAddLineToPoint(ctx,120.18, 52.16);
        CGContextAddLineToPoint(ctx,109.91, 65.51);
        CGContextAddLineToPoint(ctx,110.37, 82.34);
        CGContextAddLineToPoint(ctx,94.5, 76.7);
        CGContextAddLineToPoint(ctx,78.63, 82.34);
        CGContextAddLineToPoint(ctx,79.09, 65.51);
        CGContextAddLineToPoint(ctx,68.82, 52.16);
        CGContextAddLineToPoint(ctx,84.98, 47.39);
        CGContextClosePath(ctx);


        CGContextDrawPath(ctx, kCGPathFillStroke);
    }

    @end
    KCView.m

    //
    //  KCView.m
    //  CALayer
    //
    //  Created by Kenshin Cui on 14-3-22.
    //  Copyright (c) 2014年 Kenshin Cui. All rights reserved.
    //

    #import "KCView.h"
    #import "KCLayer.h"

    @implementation KCView

    -(instancetype)initWithFrame:(CGRect)frame{
        NSLog(@"initWithFrame:");
        if (self=[super initWithFrame:frame]) {
            KCLayer *layer=[[KCLayer alloc]init];
            layer.bounds=CGRectMake(0, 0, 185, 185);
            layer.position=CGPointMake(160,284);
            layer.backgroundColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;

            //显示图层
            [layer setNeedsDisplay];

            [self.layer addSublayer:layer];
        }
        return self;
    }

    -(void)drawRect:(CGRect)rect{
        NSLog(@"2-drawRect:");
        NSLog(@"CGContext:%@",UIGraphicsGetCurrentContext());//得到的当前图形上下文正是drawLayer中传递的
        [super drawRect:rect];

    }

    -(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
        NSLog(@"1-drawLayer:inContext:");
        NSLog(@"CGContext:%@",ctx);
        [super drawLayer:layer inContext:ctx];

    }

    @end
    KCMainViewController.m

    //
    //  KCMainViewController.m
    //  CALayer
    //
    //  Created by Kenshin Cui on 14-3-22.
    //  Copyright (c) 2014年 Kenshin Cui. All rights reserved.
    //

    #import "KCMainViewController.h"
    #import "KCView.h"

    @interface KCMainViewController ()

    @end

    @implementation KCMainViewController

    - (void)viewDidLoad {
        [super viewDidLoad];

        KCView *view=[[KCView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        view.backgroundColor=[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];


        [self.view addSubview:view];
    }

    @end

###Core Animation
#####基础动画
#####关键帧动画
#####动画组
#####转场动画
#####逐帧动画

###UIView动画封装
#####基础动画
#####关键帧动画
#####转场动画