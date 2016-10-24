#UIViewController
在UIKit中UIViewController如下：
![](/Users/tangdaoyong/Desktop/Objective-C/TDYOCFramework/TDYCocoaTouch/TDYUIKit/1336457838_2938.png)
就iOS开发来说，UIViewController就最核心的类型之一。Controller作为整个UI视图的控制器，对于用户的输入做出逻辑处理，例如用户点击某个按钮应该执行什么操作等；View角色只负责显示视图，view的这部分就是我们在nib或者storyboard设计的UI了。Model也就是我们的数据模型，例如从Core data中加载的实体类等等。这整个架构分工清晰，降低了代码的耦合度。今天我们要学习的角色就是Controller。

UIViewController与UIWindow、UIView的关系如下 图所示:

![](/Users/tangdaoyong/Desktop/Objective-C/TDYOCFramework/TDYCocoaTouch/TDYUIKit/20141202081454106.png)
###UIViewController加载视图
UIViewController有两种加载方式，第一种是通过手动加载xib文件来加载视图，第二种是直接通过代码来创建View Controller中的师徒来加载。直接看示例吧。
#####1.xib加载
在创建一个xib文件，将File's Owner设置为对应的UIViewController类型，然后关联File's Owner的view与xib中的root view(在创建UIViewController时自动创建了xib的话不需要这一步，只有分开创建时才需要手动建立关联，否则会报错。)，然后通过如下代码即可创建：

    MainViewController *vc=[[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    self.window.rootViewController = vc;

    - (void)awakeFromNib{
      //从xib中唤醒。
    }
#####2.代码创建
思路就是将View添加到UIViewController的root view中，在UIViewController启动时默认会从与其关联的xib或者storyboard中加载视图，如果没有找到则root view为nil。我们可以覆写loadView方法，通过代码的形式向里面添加view。

    - (void) loadView{
        //这里面写了代码才会调用
    }
#####3.stroyBoard加载ViewController
    ViewController2 * viewController2 = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController2"];
###UIViewController的生命周期
ViewController生命周期会经历初始化、加载视图、销毁视图、生命结束等过程。
    //类的初始化方法,继承自NSObject,只加载一次
    + (void)initialize;
    //对象初始化方法，初始化ViewController本身。
    - (instancetype)init;
    //从归档初始化
    - (instancetype)initWithCoder:(NSCoder *)coder;
    //加载视图，当view需要被展示而它却是nil时，viewController会调用该方法，如果代码构建View的话需要重写此方法。
    -(void)loadView;
    //将要加载视图，执行完loadView后继续执行viewDidLoad，loadView时还没有view，而viewDidLoad时view已经创建好了。
    - (void)viewDidLoad;
    //将要布局子视图
    -(void)viewWillLayoutSubviews;
    //已经布局子视图
    -(void)viewDidLayoutSubviews;
    //内存警告
    - (void)didReceiveMemoryWarning;
    //已经展示
    -(void)viewDidAppear:(BOOL)animated;
    //将要展示
    -(void)viewWillAppear:(BOOL)animated;
    //将要消失
    -(void)viewWillDisappear:(BOOL)animated;
    //已经消失
    -(void)viewDidDisappear:(BOOL)animated;
    //被释放，释放其他资源或内存。
    -(void)dealloc;
    //当系统内存吃紧的时候会调用该方法。
    -(void) viewDidUnload方法
#####注意
这是一个ViewController完整的声明周期，其实里面还有好多地方需要我们注意一下：

1：initialize函数并不会每次创建对象都调用，只有在这个类第一次创建对象时才会调用，做一些类的准备工作，再次创建这个类的对象，initalize方法将不会被调用，对于这个类的子类，如果实现了initialize方法，在这个子类第一次创建对象时会调用自己的initalize方法，之后不会调用，如果没有实现，那么它的父类将替它再次调用一下自己的initialize方法，以后创建也都不会再调用。因此，如果我们有一些和这个相关的全局变量，可以在这里进行初始化。

2：init方法和initCoder方法相似，只是被调用的环境不一样，如果用代码进行初始化，会调用init，从nib文件或者归档进行初始化，会调用initCoder。

3：loadView方法是开始加载视图的起始方法，除非手动调用，否则在ViewController的生命周期中没特殊情况只会被调用一次。

4：viewDidLoad方法是我们最常用的方法的，类中成员对象和变量的初始化我们都会放在这个方法中，在类创建后，无论视图的展现或消失，这个方法也是只会在将要布局时调用一次。

5：viewWillAppare：视图将要展现时会调用。

6：viewWillLayoutSubviews：在viewWillAppare后调用，将要对子视图进行布局。

7：viewDidLayoutSubviews：已经布局完成子视图。

8：viewDidAppare：视图完成显示时调用。

9：viewWillDisappare：视图将要消失时调用。

10：viewDidDisappare：视图已经消失时调用。

11：dealloc：controller被释放时调用。
###ios9新方法

    - (void)loadViewIfNeeded NS_AVAILABLE_IOS(9_0);
这个方法十分有用，调用这个方法，会将视图创建出来，并且不会忽略viewDidLoad的调用。
在iOS9中，UIViewController还增加了下面一个布尔值的属性，可以同来判断controller的view是否已经加载完成：

    @property(nullable, nonatomic, readonly, strong) UIView *viewIfLoaded NS_AVAILABLE_IOS(9_0);

###控制storyBoard中的自动跳转
在UIViewController中有如下方法可以对是否跳转进行控制：

    - (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender NS_AVAILABLE_IOS(6_0);
这个方法如果返回NO，自动跳转将不能进行，会被拒绝，需要注意的是，这个方法只会在自动的跳转时被调用，我们手动使用代码跳转StoryBoard中的连接关系时是不会被调用的，我们后面讨论。

在执行过上述方法后，如果返回YES，系统还会在执行如下一个方法，作为跳转前的准备，我们可以在这个方法中进行一些传值操作，这个方法无论使我们手动进行跳转还是storyboard中自动跳转，都会被执行：

    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender NS_AVAILABLE_IOS(5_0);
sugur对象中封装了相关的ViewController，可以使用segue.destinationViewController获取。

segue在StoryBoard中除了用来自动正向跳转外，我们还可以进行反向的跳转，类似pop和dismiss方法，这种segue被称为unwind sugue。例如，我们有一个controller1和一个controllert2，要使用unwind segue从2返回1，我们需要在2中实现如下格式的方法：

    - (IBAction)unwindSegueToViewController:(UIStoryboardSegue *)segue {
        NSLog(@"unwindSegueToViewController");
    }

###2、使用代码跳转Storyboard中的controller

我们除了在Storyboard中拉拉扯扯可以进行控制器的跳转外，我们也可以使用代码来跳转Storyboard中segue连接关系。

 在Storyboard中两个控制器间建立一个segue联系，我们可以取一个名字：

在触发跳转的方法中，使用如下方法进行跳转，这里面的参数id就是我们取得segue的id：

    - (void)performSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender NS_AVAILABLE_IOS(5_0);
下面三个属性我们可以获取controller的nib文件名，其storyBoard和其Bundle:

    @property(nullable, nonatomic, readonly, copy) NSString *nibName;
    @property(nullable, nonatomic, readonly, strong) NSBundle *nibBundle;
    @property(nullable, nonatomic, readonly, strong) UIStoryboard *storyboard NS_AVAILABLE_IOS(5_0);

###从属关系
1、parentViewController

        UIViewController里面封装了一个数组，可以存放其子ViewController，系统中使用的例子就是导航和tabBar这类的控制器，我们使用如下方法可以直接访问这些父的controller：

    @property(nullable,nonatomic,weak,readonly) UIViewController *parentViewController;
2、模态跳转中Controller的从属

        在我们进行控制器的跳转时，只要控制器没有被释放，我们都可以顺藤摸瓜的找到它，使用如下两个方法：

    //其所present的contller，比如，A和B两个controller，A跳转到B，那么A的presentedViewController就是B
    @property(nullable, nonatomic,readonly) UIViewController *presentedViewController  NS_AVAILABLE_IOS(5_0);
    //和上面的方法刚好相反，比如，A和B两个controller，A跳转到B，那么B的presentingViewController就是A
    @property(nullable, nonatomic,readonly) UIViewController *presentingViewController NS_AVAILABLE_IOS(5_0);
了解了上面方法我们可以知道，对于反向传值这样的问题，我们根本不需要代理，block，通知等这样的复杂手段，只需要获取跳转到它的Controller，直接设置即可。

###UIViewController的模态跳转及动画特效

单纯的UIViewController中，我们使用最多的是如下的两个方法，一个向前跳转，一个向后返回:

    - (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);
    - (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);
从方法中，我们可以看到，有animated这个参数，来选择是否有动画特效，默认的动画特效是像抽屉一样从手机屏幕的下方向上弹起，当然，这个效果我们可以进行设置，UIViewController有如下一个属性来设置动画特效：

    @property(nonatomic,assign) UIModalTransitionStyle modalTransitionStyle NS_AVAILABLE_IOS(3_0);
注意，这个要设置的是将要跳转到的controller，枚举如下：

        typedef NS_ENUM(NSInteger, UIModalTransitionStyle) {
        UIModalTransitionStyleCoverVertical = 0,//默认的，从下向上覆盖
        UIModalTransitionStyleFlipHorizontal ,//水平翻转
        UIModalTransitionStyleCrossDissolve,//溶解
        UIModalTransitionStylePartialCurl ,从下向上翻页
        };
除了跳转的效果，还有一个属性可以设置弹出的controler的填充效果，但是这个属性只在pad上有效，在iphone上无效，都是填充到整个屏幕：

        @property(nonatomic,assign) UIModalPresentationStyle modalPresentationStyle NS_AVAILABLE_IOS(3_2);
    //枚举如下：
        typedef NS_ENUM(NSInteger, UIModalPresentationStyle) {
            UIModalPresentationFullScreen = 0,//填充整个屏幕
            UIModalPresentationPageSheet,//留下状态栏
            UIModalPresentationFormSheet,//四周留下变暗的空白
            UIModalPresentationCurrentContext ,//和跳转到它的控制器保持一致
            UIModalPresentationCustom NS_ENUM_AVAILABLE_IOS(7_0),//自定义
            UIModalPresentationOverFullScreen NS_ENUM_AVAILABLE_IOS(8_0),
            UIModalPresentationOverCurrentContext NS_ENUM_AVAILABLE_IOS(8_0),
            UIModalPresentationPopover NS_ENUM_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED,
            UIModalPresentationNone NS_ENUM_AVAILABLE_IOS(7_0) = -1,
        };
###支持界面旋转
    1.声明支持的旋转方向
    shouldAutorotateToInterfaceOrientation:决定支持的旋转方向(UIInterfaceOrientationIsLandscape的横向2个方向 UIInterfaceOrientationIsPortrait竖直2个方向)
    2.如何处理方向改变
    a)方向发生改变
    b)调用shouldAutorotateToInterfaceOrientation查看支持的方向
    c)调用controller的willRotateToInterfaceOrientation:duration方法
    d)触发view的自动布局(详细的看第二部分的第4点：布局)
    e)调用didRotateFromInterfaceOrientation方法
    3.为每个方向创建不同的界面
    利用notification来通知不同的状态。
例如：
    @implementation PortraitViewController  
    - (void)awakeFromNib  
    {  
        isShowingLandscapeView = NO;  
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];  
        [[NSNotificationCenter defaultCenter] addObserver:self  
                                     selector:@selector(orientationChanged:)  
                                     name:UIDeviceOrientationDidChangeNotification  
                                     object:nil];  
    }  

    - (void)orientationChanged:(NSNotification *)notification  
    {  
        UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;  
        if (UIDeviceOrientationIsLandscape(deviceOrientation) &&  
            !isShowingLandscapeView)  
        {  
            [self performSegueWithIdentifier:@"DisplayAlternateView" sender:self];  
            isShowingLandscapeView = YES;  
        }  
        else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&  
                 isShowingLandscapeView)  
        {  
            [self dismissViewControllerAnimated:YES completion:nil];  
            isShowingLandscapeView = NO;  
        }  
    }  