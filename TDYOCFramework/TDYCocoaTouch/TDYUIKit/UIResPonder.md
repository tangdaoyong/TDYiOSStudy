###UIResPonder
下面的子类有：

    1.UIApplication
    2.UIView
    3.UIViewController

###介绍：
UIKit可识别三种类型的输入事件：

    触摸事件
    加速计事件 / 运动事件
    远程控制事件
@interface UIResponder : NSObject
一个UIResponder类为那些需要响应并处理事件的对象定义了一组接口。这些事件主要分为两类：触摸事件(touch events)和运动事件(motion events)。UIResponder类为每两类事件都定义了一组接口，这个我们将在下面详细描述。
###响应链
大多数事件的分发都是依赖响应链的。响应链是由一系列链接在一起的响应者组成的。一般情况下，一条响应链开始于第一响应者，结束于application对象。如果一个响应者不能处理事件，则会将事件沿着响应链传到下一响应者。

###构建响应链
我们都知道在一个App中，所有视图是按一定的结构组织起来的，即树状层次结构。除了根视图外，每个视图都有一个父视图；而每个视图都可以有0个或多个子视图。而在这个树状结构构建的同时，也构建了一条条的事件响应链。
###确定第一响应者
当用户触发某一事件(触摸事件或运动事件)后，UIKit会创建一个事件对象(UIEvent)，该对象包含一些处理事件所需要的信息。然后事件对象被放到一个事件队列中。这些事件按照先进先出的顺序来处理。当处理事件时，程序的UIApplication对象会从队列头部取出一个事件对象，将其分发出去。通常首先是将事件分发给程序的主window对象，对于触摸事件来讲，window对象会首先尝试将事件分发给触摸事件发生的那个视图上。这一视图通常被称为hit-test视图，而查找这一视图的过程就叫做hit-testing。

系统使用hit-testing来找到触摸下的视图，它检测一个触摸事件是否发生在相应视图对象的边界之内(即视图的frame属性，这也是为什么子视图如果在父视图的frame之外时，是无法响应事件的)。如果在，则会递归检测其所有的子视图。包含触摸点的视图层次架构中最底层的视图就是hit-test视图。在检测出hit-test视图后，系统就将事件发送给这个视图来进行处理。

###事件传递
最有机会处理事件的对象是hit-test视图或第一响应者。如果这两者都不能处理事件，UIKit就会将事件传递到响应链中的下一个响应者。每一个响应者确定其是否要处理事件或者是通过nextResponder方法将其传递给下一个响应者。这一过程一直持续到找到能处理事件的响应者对象或者最终没有找到响应者。
![](/Users/tangdaoyong/Desktop/Objective-C/TDYOCFramework/TDYCocoaTouch/TDYUIKit/1877957-86f0ba0e2d6f50c6.jpeg)

当系统检测到一个事件时，将其传递给初始对象，这个对象通常是一个视图。然后，会按以下路径来处理事件(我们以上图为例)：

    1.初始视图(initial view)尝试处理事件。如果它不能处理事件，则将事件传递给其父视图。
    2.初始视图的父视图(superview)尝试处理事件。如果这个父视图还不能处理事件，则继续将视图传递给上层视图。
    3.上层视图(topmost view)会尝试处理事件。如果这个上层视图还是不能处理事件，则将事件传递给视图所在的视图控制器。
    4.视图控制器会尝试处理事件。如果这个视图控制器不能处理事件，则将事件传递给窗口(window)对象。
    5.窗口(window)对象尝试处理事件。如果不能处理，则将事件传递给单例app对象。
    6.如果app对象不能处理事件，则丢弃这个事件。
    从上面可以看到，视图、视图控制器、窗口对象和app对象都能处理事件。另外需要注意的是，手势也会影响到事件的传递。

以上便是响应链的一些基本知识。有了这些知识，我们便可以来看看UIResponder提供给我们的一些方法了。

###管理响应链
UIResponder提供了几个方法来管理响应链，包括让响应对象成为第一响应者、放弃第一响应者、检测是否是第一响应者以及传递事件到下一响应者的方法，我们分别来介绍一下。

- (nullable UIResponder*)nextResponder;
UIResponder类并不自动保存或设置下一个响应者，该方法的默认实现是返回nil。子类的实现必须重写这个方法来设置下一响应者。UIView的实现是返回管理它的UIViewController对象(如果它有)或者其父视图。而UIViewController的实现是返回它的视图的父视图；UIWindow的实现是返回app对象；而UIApplication的实现是返回nil。所以，响应链是在构建视图层次结构时生成的。

- (BOOL)isFirstResponder;是否是第一响应者
- (BOOL)canBecomeFirstResponder;  //判断是否是可以成为第一响应者  // default is NO
- (BOOL)becomeFirstResponder;//成为第一响应者
- (BOOL)canResignFirstResponder;  //是否可以辞去第一响应者  // default is YES
- (BOOL)resignFirstResponder;//取消第一响应者

###触发事件
其中touches开头的方法是触摸事件相关的方法；presses开头的方法，是iOS9加入的给iPhone6s等支持Deep Press功能的设备使用的相关方法；motion开头的则是给设备的陀螺仪和加速传感器使用的方法，用于获取晃动等事件。

#####1.响应触摸事件

    //手指按下的时候调用
    - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
    //手指移动的时候调用
    - (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
    //手指抬起的时候调用
    - (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
    //取消(非正常离开屏幕,意外中断)
    - (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;

    - (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
    通知接收者一个动作开始了。
    当一个动作开始了和结束了的时候iOS才会通知接收者。it doesn’t report individual shakes. 接收者必须是接收动作事件的第一响应者。
    2.- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
    通知接收者一个动作结束了。
    3.- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
    一个动作被取消了。雷同- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event

    // 3D Touch相关方法，当前触摸对象触摸时力量改变所触发的事件,返回值是UITouchPropertyie
    - (void)touchesEstimatedPropertiesUpdated:(NSSet * _Nonnull)touches NS_AVAILABLE_IOS(9_1);
    - (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event NS_AVAILABLE_IOS(9_0);
    - (void)pressesChanged:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event NS_AVAILABLE_IOS(9_0);
    - (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event NS_AVAILABLE_IOS(9_0);
    - (void)pressesCancelled:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event NS_AVAILABLE_IOS(9_0);
默认情况下，多点触摸是被禁用的。为了接受多点触摸事件，我们需要设置响应视图的multipleTouchEnabled属性为YES。

#####2.响应移动事件

    //移动事件开始
    - (void)motionBegan:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(3_0);
    //移动事件结束
    - (void)motionEnded:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(3_0);
    //移动事件取消
    - (void)motionCancelled:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(3_0);
与触摸事件不同的是，运动事件只有开始与结束操作；它不会报告类似于晃动这样的事件。这几个方法的默认操作也是什么都不做。不过，UIKit中UIResponder的子类，尤其是UIView，这几个方法的实现都会把消息传递到响应链上。

#####3.响应远程控制事件
远程控制事件来源于一些外部的配件，如耳机等。用户可以通过耳机来控制视频或音频的播放。接收响应者对象需要检查事件的子类型来确定命令(如播放，子类型为UIEventSubtypeRemoteControlPlay)，然后进行相应处理。

    - (void)remoteControlReceivedWithEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(4_0);
我们可以在子类中实现该方法，来处理远程控制事件。不过，为了允许分发远程控制事件，我们必须调用UIApplication的beginReceivingRemoteControlEvents方法；而如果要关闭远程控制事件的分发，则调用endReceivingRemoteControlEvents方法。

###验证命令
在我们的应用中，经常会处理各种菜单命令，如文本输入框的”复制”、”粘贴”等。UIResponder为此提供了两个方法来支持此类操作。首先使用以下方法可以启动或禁用指定的命令：

    - (BOOL)canPerformAction:(SEL)action withSender:(nullable id)sender NS_AVAILABLE_IOS(3_0);
另外，我们可以使用以下方法来获取可以响应某一行为的接收者：

    - (nullable id)targetForAction:(SEL)action withSender:(nullable id)sender NS_AVAILABLE_IOS(7_0);
在对象需要调用一个action操作时调用该方法。默认的实现是调用canPerformAction:withSender:方法来确定对象是否可以调用action操作。如果可以，则返回对象本身，否则将请求传递到响应链上。如果我们想要重写目标的选择方式，则应该重写这个方法。下面这段代码演示了一个文本输入域禁用拷贝/粘贴操作：

    - (id)targetForAction:(SEL)action withSender:(id)sender
    {
      UIMenuController *menuController = [UIMenuController sharedMenuController];
      if (action == @selector(selectAll:) || action == @selector(paste:) ||action == @selector(copy:) || action == @selector(cut:)) {
        if (menuController) {
          [UIMenuController sharedMenuController].menuVisible = NO;
        }
        return nil;
      }
      return [super targetForAction:action withSender:sender];
    }

###获取Undo管理器
默认情况下，程序的每一个window都有一个undo管理器，它是一个用于管理undo和redo操作的共享对象。然而，响应链上的任何对象的类都可以有自定义undo管理器。例如，UITextField的实例的自定义管理器在文件输入框放弃第一响应者状态时会被清理掉。当需要一个undo管理器时，请求会沿着响应链传递，然后UIWindow对象会返回一个可用的实例。
UIResponder提供了一个只读方法来获取响应链中共享的undo管理器，

    @property(nullable, nonatomic,readonly) NSUndoManager *undoManager NS_AVAILABLE_IOS(3_0);
我们可以在自己的视图控制器中添加undo管理器来执行其对应的视图的undo和redo操作。
返回在响应链中最近的共享undo manager。
默认的，每个应用程序的window都有一个undo manager：a shared object for managing undo and redo operations.然而，在响应链中任何对象的类都有它们自己的undo manager.
###Managing Input Views

    @property (readonly, retain) UIView *inputView
当一个对象变成第一响应者的时候显示的View
UITextField和UITextView如果设置了inputView那么在becomeFirstResponder时不会显示键盘，而现实自定义的inputView；如果设置了inputAccessoryView那么在becomeFirstResponder时会在键盘的顶端显示自定义的inputAccessoryView。

    @property (readonly, retain) UIView *inputAccessoryView
    - (void)reloadInputViews
当对象成为第一响应者的时候更新inputView和accessoryView。

文／闭上的眼镜（简书作者）
原文链接：http://www.jianshu.com/p/632f97504595
著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。