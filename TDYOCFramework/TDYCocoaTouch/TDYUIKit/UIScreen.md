#UIScreen屏幕
![](/Users/tangdaoyong/Desktop/Objective-C/TDYOCFramework/TDYCocoaTouch/TDYUIKit/20141202081454106.png)
通过这个类我们可以获取一些关于屏幕的信息，通常用来获取屏幕尺寸。
    // 返回带有状态栏的 Rect
    let screenBounds = UIScreen.mainScreen().bounds

    // 返回不含状态栏的 Rect
    let viewBounds = UIScreen.mainScreen().applicationFrame
UIScreen对象定义了基于硬件显示的相关属性。iOS设备有一个主屏幕和零个或多个附带屏幕。tvOS设备有一个主屏幕，就是设备相连接的电视。使用这个类来获取每一个设备显示屏幕的对象。每一个屏幕对象定义了相关的边界矩形和其它有趣的属性，例如它的亮度。
在iOS8之前，屏幕的bounds总能反映出屏幕尺寸，这个方向总是向上的，旋转设备和颠倒设备都不会改变。在iOS8之后，屏幕的bounds属性会被屏幕的方向而影响，这意味着设备的bounds在横屏的时候会不一样。如果App依赖于屏幕尺寸的话，可以使用fixedCoordinateSpace属性座位一个固定的参考点作为计算。
处理屏幕断开和连接的通知
当用户连接或断开一个显示iOS的设备，系统会发送通知给App，使用一个长生命周期的对象去监听它，例如AppDelegate。在任何时候都有可能收到连接和断开的通知，甚至在你的App后台运行着。如果你的App暂停通知到来后,通知再次排队，直到你的App开始前台运行，它就会被送到你的观察者对象那里。
当你收到一个通知告诉你新的外部显示器已连接,你尽你所能去使用更多的屏幕空间。为了使用空间，你要创建一个窗口对象,分配新的屏幕的屏幕属性和去显示窗口。这样做会导致当你App前台运行时显示在窗口的内容。如果你不为额外的屏幕创建一个窗口,或者如果你创建一个窗口,但没有表现出来,一个黑色的字段显示在新的外部显示器。
处理连接和断开的通知告诉你两个简单处理通知的方法。连接处理的方法创建了一个二级窗口，将它与新连接的屏幕，询问其中一个应用程序的视图控制器(由自定义viewController属性)来添加一些内容的窗口，并显示它。断开处理的方法释放窗口和通知主要视图控制器，以便它可以相应地调整其界面。
    - (void)handleScreenConnectNotification:(NSNotification*)aNotification {
        UIScreen*    newScreen = [aNotification object];
        CGRect        screenBounds = newScreen.bounds;

        if (!_secondWindow) {
            _secondWindow = [[UIWindow alloc] initWithFrame:screenBounds];
            _secondWindow.screen = newScreen;

            //设置并显示初始界面窗口
            [self.viewController displaySelectionInSecondaryWindow:_secondWindow];
            [_secondWindow makeKeyAndVisible];
        }
    }

    - (void)handleScreenDisconnectNotification:(NSNotification*)aNotification {
        if (_secondWindow) {
            //隐藏和删除窗口
            _secondWindow.hidden = YES;
            [_secondWindow release];
            _secondWindow = nil;

            //更新主屏幕的显示
            [self.viewController displaySelectionOnMainScreen];
        }
    }
配置外置屏幕显示模式
多个屏幕支持多个分辨率，有一些使用不同的分辨率。屏幕对象在默认情况下使用常用的现实模式，但是你可以改变这一模式以适配你的内容。例如，如果你使用OpenGL ES去编写你的游戏，而游戏是根据640\*480去设计的，你可能需要更改屏幕模式。
如果你打算使用一个非默认模式下的屏幕模式，在连接窗口之前你就应该更改完毕。UIScreenMode这个类定义一个单一的屏幕模式。你可以从它的availableModes属性中获取屏幕支持的模式列表，并在其中找到你所需要的模式。
想了解更多的屏幕模式，请看UIScreenMode类的介绍
获取可用的屏幕

    mainScreen //类方法 返回主屏幕
    screens //类方法 返回一个装有所有屏幕的数组
    mirroredScreen //属性 外部显示器的镜像(readonly)
获取屏幕坐标空间

    coordinateSpace //属性 当前屏幕的坐标空间
    fixedCoordinateSpace //属性 被修正后的坐标空间
获取边界矩形信息

    bounds //属性 屏幕的bounds
    applicationFrame //iOS9 属性 窗口的Frame
    nativeBounds //属性 物理屏幕的像素
    nativeScale //属性 设备物理屏幕的比例因子
    scale //属性 屏幕的设计比例因子
访问屏幕模式

    currentMode //属性 当前的屏幕模式
    preferredMode //属性 最佳的屏幕模式
    availableModes //属性 可用的屏幕模式
获取一个显示连接

    displayLinkWithTarget:selector: //对象方法 返回一个当前屏幕显示的链接对象
设置显示亮度

    brightness //属性 屏幕亮度等级
    wantsSoftwareDimming //属性 使用软件改变亮度模式
设置显示的扫描补偿

    overscanCompensation //属性 设置弥补过度扫描
    overscanCompensationInsets //属性 边缘嵌入值
    Capturing a Screen Snapshot
捕捉屏幕快照

    snapshotViewAfterScreenUpdates: //对象方法 返回一个基于当前屏幕的一个快照
处理改变屏幕的焦点

    focusedView //属性 当前焦点的视图
    supportsFocus //属性 判断是否支持遥控输入
    Constants
    常量

    UIScreenOverscanCompensation
    描述了不同的补偿技术在屏幕的边缘像素的损失。

    typedef enum {
       UIScreenOverscanCompensationScale,
       UIScreenOverscanCompensationInsetBounds,
       UIScreenOverscanCompensationNone,
       UIScreenOverscanCompensationInsetApplicationFrame,
    } UIScreenOverscanCompensation;
    UIScreenOverscanCompensationScale //使所有像素在屏幕上可见。
    UIScreenOverscanCompensationInsetBounds //屏幕范围缩小，所有像素在屏幕上是可见的。
    UIScreenOverscanCompensationNone //没有发生补偿
    UIScreenOverscanCompensationInsetApplicationFrame //缩小弥补过扫描，屏幕外的忽略

Notifications
通知

UIScreenDidConnectNotification
屏幕设备连接的通知

UIScreenDidDisconnectNotification
屏幕设备断开的通知

UIScreenModeDidChangeNotification
屏幕模式变更的通知

UIScreenBrightnessDidChangeNotification
屏幕亮度变更的通知

总结
经过了解发现，iOS开发并不常用到这个类，可能除了获取屏幕宽高以外的就是改变亮度了，但是做tvOS可能需要对这个类进行了解，因为这个类可以应对Apple TV连接断开电视的相关操作，而且能对屏幕进行优化！

文／码农小姜（简书作者）
原文链接：http://www.jianshu.com/p/cf7f7dddb60b
著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。