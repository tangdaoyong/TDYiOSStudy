#UIApplication程序
[](http://www.cnblogs.com/wendingding/p/3766347.html)
[]()
###一、UIApplication
#####1.简单介绍
（1）UIApplication对象是应用程序的象征，一个UIApplication对象就代表一个应用程序。
（2）每一个应用都有自己的UIApplication对象，而且是单例的，如果试图在程序中新建一个UIApplication对象，那么将报错提示。
（3）通过[UIApplication sharedApplication]可以获得这个单例对象
（4） 一个iOS程序启动后创建的第一个对象就是UIApplication对象，且只有一个（通过代码获取两个UIApplication对象，打印地址可以看出地址是相同的）。
（5）利用UIApplication对象，能进行一些应用级别的操作
#####2.应用级别的操作示例：

1）设置应用程序图标右上角的红色提醒数字（如QQ消息的时候，图标上面会显示1，2，3条新信息等。）

@property(nonatomic) NSInteger applicationIconBadgeNumber;

代码实现和效果：

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        //创建并添加一个按钮
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 60, 30)];
        [btn setTitle:@"按钮" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor brownColor]];
        [btn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    -(void)onClick
    {
        NSLog(@"按钮点击事件");
        //错误，只能有一个唯一的UIApplication对象，不能再进行创建
    //    UIApplication *app=[[UIApplication alloc]init];

        //通过sharedApplication获取该程序的UIApplication对象
        UIApplication *app=[UIApplication sharedApplication];
        app.applicationIconBadgeNumber=123;
    }
效果好通知提示是一样的。

2）设置联网指示器的可见性（上面转动的菊花）

    @property(nonatomic,getter=isNetworkActivityIndicatorVisible) BOOL networkActivityIndicatorVisible;
代码和效果:

      //设置指示器的联网动画
        app.networkActivityIndicatorVisible=YES;


3）管理状态栏
从iOS7开始，系统提供了2种管理状态栏的方式
a.通过UIViewController管理（每一个UIViewController都可以拥有自己不同的状态栏）.
在iOS7中，默认情况下，状态栏都是由UIViewController管理的，UIViewController实现下列方法就可以轻松管理状态栏的可见性和样式

    状态栏的样式(UIStatusBarStyle)preferredStatusBarStyle;

    状态栏的可见性　　-(BOOL)prefersStatusBarHidden;

    #pragma mark-设置状态栏的样式
    -(UIStatusBarStyle)preferredStatusBarStyle
    {
        //设置为白色
        //return UIStatusBarStyleLightContent;
        //默认为黑色
         return UIStatusBarStyleDefault;
    }
    #pragma mark-设置状态栏是否隐藏（否）
    -(BOOL)prefersStatusBarHidden
    {
        return NO;
    }
b.通过UIApplication管理（一个应用程序的状态栏都由它统一管理）

如果想利用UIApplication来管理状态栏，首先得修改Info.plist的设置
Info.plist -> view controller-based status 设置为NO。
![]()

代码：

      //通过sharedApplication获取该程序的UIApplication对象
        UIApplication *app=[UIApplication sharedApplication];
        app.applicationIconBadgeNumber=123;

        //设置指示器的联网动画
        app.networkActivityIndicatorVisible=YES;
        //设置状态栏的样式
        //app.statusBarStyle=UIStatusBarStyleDefault;//默认（黑色）
        //设置为白色+动画效果
          [app setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        //设置状态栏是否隐藏
        app.statusBarHidden=YES;
          //设置状态栏是否隐藏+动画效果
        [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

c.补充

既然两种都可以对状态栏进行管理，那么什么时候该用什么呢？
如果状态栏的样式只设置一次，那就用UIApplication来进行管理；
如果状态栏是否隐藏，样式不一样那就用控制器进行管理。
UIApplication来进行管理有额外的好处，可以提供动画效果。
4）openURL:方法

UIApplication有个功能十分强大的openURL:方法

    - (BOOL)openURL:(NSURL*)url;

openURL:方法的部分功能有

    打电话  UIApplication *app = [UIApplicationsharedApplication]; [app openURL:[NSURLURLWithString:@"tel://10086"]];

    发短信  [app openURL:[NSURLURLWithString:@"sms://10086"]];

    发邮件  [app openURL:[NSURLURLWithString:@"mailto://12345@qq.com"]];

    打开一个网页资源 [app openURL:[NSURLURLWithString:@"http://ios.itcast.cn"]];

    打开其他app程序   openURL方法，可以打开其他APP。

URL补充：
URL：统一资源定位符，用来唯一的表示一个资源。
URL格式:协议头：//主机地址/资源路径
网络资源：http/ ftp等   表示百度上一张图片的地址   http://www.baidu.com/images/20140603/abc.png
本地资源：file:///users/apple/desktop/abc.png(主机地址省略)

###二、UIApplication Delegate
1.简单说明

所有的移动操作系统都有个致命的缺点：app很容易受到打扰。比如一个来电或者锁屏会导致app进入后台甚至被终止。
还有很多其它类似的情况会导致app受到干扰，在app受到干扰时，会产生一些系统事件，这时UIApplication会通知它的delegate对象，让delegate代理来处理这些系统事件。
作用：当被打断的时候，通知代理进入到后台。

![]()

每次新建完项目，都有个带有“AppDelegate”字眼的类，它就是UIApplication的代理,NJAppDelegate默认已经遵守了UIApplicationDelegate协议，已经是UIApplication的代理。



2.代理方法

     1 #import "YYAppDelegate.h"
     2 
     3 @implementation YYAppDelegate
     4 
     5 // 当应用程序启动完毕的时候就会调用(系统自动调用)
     6 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
     7 {
     8     NSLog(@"didFinishLaunchingWithOptions");
     9     return YES;
    10 }
    11 
    12 // 即将失去活动状态的时候调用(失去焦点, 不可交互)
    13 - (void)applicationWillResignActive:(UIApplication *)application
    14 {
    15     NSLog(@"ResignActive");
    16 }
    17 
    18 // 重新获取焦点(能够和用户交互)
    19 - (void)applicationDidBecomeActive:(UIApplication *)application
    20 {
    21     NSLog(@"BecomeActive");
    22 }
    23 
    24 // 应用程序进入后台的时候调用
    25 // 一般在该方法中保存应用程序的数据, 以及状态
    26 - (void)applicationDidEnterBackground:(UIApplication *)application
    27 {
    28     NSLog(@"Background");
    29 }
    30 
    31 // 应用程序即将进入前台的时候调用
    32 // 一般在该方法中恢复应用程序的数据,以及状态
    33 - (void)applicationWillEnterForeground:(UIApplication *)application
    34 {
    35     NSLog(@"Foreground");
    36 }
    37 
    38 // 应用程序即将被销毁的时候会调用该方法
    39 // 注意:如果应用程序处于挂起状态的时候无法调用该方法
    40 - (void)applicationWillTerminate:(UIApplication *)application
    41 {
    42 }
    43 
    44 // 应用程序接收到内存警告的时候就会调用
    45 // 一般在该方法中释放掉不需要的内存
    46 - (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
    47 {
    48     NSLog(@"MemoryWarning");
    49 }
    50 @end

应用程序一般有五个状态：官方文档app.states

###三、程序启动原理
UIApplicationMain

main函数中执行了一个UIApplicationMain这个函数

    intUIApplicationMain(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName);

argc、argv：直接传递给UIApplicationMain进行相关处理即可

principalClassName：指定应用程序类名（app的象征），该类必须是UIApplication(或子类)。如果为nil,则用UIApplication类作为默认值

 delegateClassName：指定应用程序的代理类，该类必须遵守UIApplicationDelegate协议

UIApplicationMain函数会根据principalClassName创建UIApplication对象，根据delegateClassName创建一个delegate对象，并将该delegate对象赋值给UIApplication对象中的delegate属性

接着会建立应用程序的Main Runloop（事件循环），进行事件的处理(首先会在程序完毕后调用delegate对象的application:didFinishLaunchingWithOptions:方法)

程序正常退出时UIApplicationMain函数才返回

    #import <UIKit/UIKit.h>

    #import "YYAppDelegate.h"

    int main(int argc, char * argv[])
    {
        @autoreleasepool {
            // return UIApplicationMain(argc, argv, nil, NSStringFromClass([YYAppDelegate class]));
            // return UIApplicationMain(argc, argv, @"UIApplication", NSStringFromClass([YYAppDelegate class]));
            /*
             argc: 系统或者用户传入的参数个数
             argv: 系统或者用户传入的实际参数
             1.根据传入的第三个参数创建UIApplication对象
             2.根据传入的第四个产生创建UIApplication对象的代理
             3.设置刚刚创建出来的代理对象为UIApplication的代理
             4.开启一个事件循环
             */
             return UIApplicationMain(argc, argv, @"UIApplication", @"YYAppDelegate");
        }
    }

系统入口的代码和参数说明：

argc:系统或者用户传入的参数
argv:系统或用户传入的实际参数
1.根据传入的第三个参数，创建UIApplication对象
2.根据传入的第四个产生创建UIApplication对象的代理
3.设置刚刚创建出来的代理对象为UIApplication的代理
4.开启一个事件循环（可以理解为里面是一个死循环）这个时间循环是一个队列（先进先出）先添加进去的先处理

ios程序启动原理
![]()
### 四、程序启动的完整过程

1.main函数

2.UIApplicationMain

* 创建UIApplication对象

* 创建UIApplication的delegate对象

3.delegate对象开始处理(监听)系统事件(没有storyboard)

* 程序启动完毕的时候, 就会调用代理的application:didFinishLaunchingWithOptions:方法

* 在application:didFinishLaunchingWithOptions:中创建UIWindow

* 创建和设置UIWindow的rootViewController

* 显示窗口

3.根据Info.plist获得最主要storyboard的文件名,加载最主要的storyboard(有storyboard)

* 创建UIWindow

* 创建和设置UIWindow的rootViewController

* 显示窗口

