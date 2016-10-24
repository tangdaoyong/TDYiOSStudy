#UIView视图
![](/Users/tangdaoyong/Desktop/Objective-C/TDYOCFramework/TDYCocoaTouch/TDYUIKit/20150409084600097.png)
>http://www.cocoachina.com/ios/20150828/13244.html
UIView表示屏幕上的一块矩形区域，它在App中占有绝对重要的地位，因为IOS中几乎所有可视化控件都是UIView的子类。负责渲染区域的内容，并且响应该区域内发生的触摸事件
UIView的功能 1.管理矩形区域里的内容2.处理矩形区域中的事件3.子视图的管理 4.还能实现动画  UIView的子类也具有这些功能
###三个结构体 CGPoint、CGSize、CGRect
    1.  CGPoint

    struct CGPoint {  
      CGFloat x;  
      CGFloat y;  
    };  

    typedef struct CGPoint CGPoint;  
    看到这个想必你已经懂了，不再解释。

    2.CGSize

    struct CGSize {  
      CGFloat width;  
      CGFloat height;  
    };  

    typedef struct CGSize CGSize;  
    不解释。

    3.CGRect

    struct CGRect {  
      CGPoint origin;  //偏移是相对父视图的  
      CGSize size;  
    };  
    typedef struct CGRect CGRect;  
    同样 不解释。

这三个结构体均在一个头文件里：CGGeometry.h
###视图的最基本属性
frame和center都是相对于父视图的，bounds是相对于自身的frame   是CGRect  frame的origin是相对于父视图的左上角原点(0,0)的位置，改变视图的frame会改变center
center  是CGPoint  指的就是整个视图的中心点，改变视图的center也会改变frame
bounds 是CGRect  是告诉子视图本视图的原点位置(通俗的说就是，子视图的frame的origin与父视图的bounds的origin的差，就是子视图相对于父视图左上角的位置，如果结果为负，则子视图在父视图外)

###几个基本界面元素：window（窗口）、视图（view）
#####1.UIView

下面来认识一下UIView类，这个类继承自UIResponder,看这个名字我们就知道它是负责显示的画布，如果说把window比作画框的话。我们就是不断地在画框上移除、更换或者叠加画布，或者在画布上叠加其他画布，大小当然 由绘画者来决定了。有了画布，我们就可以在上面任意施为了。很多简单的东西我会把库里面的内容贴出来，如果东西太多贴出来就不太好，朋友们自己去库文件里面看吧。这个类在UIView.h里面。下面我们先学习一些基础的东西，其他的东东会在以后慢慢展开。
 
    UIView* myView =[[ UIView alloc]initWithFrame:CGRectMake(0.0,0.0,200.0,400.0)];     //这里创建了一块画布，定义了相对于父窗口的位置， 以及大小。  

我们可以把这块画布加到其他画布上，具体方法后面会讲到。我们还可以在这块画布上画上其它好玩的东东，具体情形后面会一一讲解。
#####UIWindow

UIWindow继承自UIView，关于这一点可能有点逻辑障碍，画框怎么继承自画布呢？不要过于去专牛角尖，画框的形状不就是跟画布一样吗？拿一块画布然后用一些方法把它加强，是不是可以当一个画框用呢？这也是为什么 一个view可以直接加到另一个view上去的原因了。
看一下系统的初始化过程（在application didFinishLauchingWithOptions里面）：

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];  
    self.window.backgroundColor = [UIColor grayColor];       //给window设置一个背景色  

    [self.window makeKeyAndVisible];     //让window显示出来  
#####UIScreen类代表了屏幕，通过这个类我们可以获取一些想要的东东


    CGRect screenBounds = [ [UIScreen mainScreen]bounds];    //返回的是带有状态栏的Rect 
    CGRect viewBounds = [ [UIScreen mainScreen]applicationFrame];    //不包含状态栏的Rect  

    //screenBounds 与 viewBounds 均是相对于设备屏幕来说的  
    //所以 screenBounds.origin.x== 0.0 ;   screenBounds.oringin.y = 0.0;     
    screenBounds.size.width == 320;  screenBounds.size.height == 480(或者其他分辨率有所差异)  
    //所以 viewBounds.origin.x== 0.0 ;   		viewBounds.oringin.y = 20.0;(因为状态栏的高度是20像素)   viewBounds.size.width == 320;
    viewBounds.size.height == 480  
    //取得StatusBar的位置和大小  
    [self.view addSubview:theToolbar];  
    CGRect statusBarRect = [[UIApplication sharedApplication]statusBarFrame];  

    NSLog(@\"%@\", NSStringFromCGRect(statusBarRect));

###UIView的方法

一个 UIView 里面可以包含许多的 Subview（其他的 UIView），而这些 Subview 彼此之间是有所谓的阶层关系，这有点类似绘图软体中图层的概念，下面程式码示演示了几个在管理图层（Subview）上常用的方法，其程式码如下。
 
1.首先是大家最常使用的新增和移除Subview。
 ￼
    [Subview removeFromSuperview];     //将Subview从当前的UIView中移除 
    [UIView addSubview:Subview];     //替UIView增加一个Subview  

2.在UIView中将Subview往前或是往后移动一个图层，往前移动会覆盖住较后层的 Subview，而往后移动则会被较上层的Subview所覆盖。
 ￼
    [UIView bringSubviewToFront:Subview];       //将Subview往前移动一个图层（与它的前一个图层对调位置）
    [UIView sendSubviewToBack:Subview];      //将Subview往后移动一个图层（与它的后一个图层对调位置）
  
3.在UIView中使用索引Index交换两的Subview彼此的图层层级。

    [UIView exchangeSubviewAtIndex:indexA withSubviewAtIndex:indexB];    //交换两个图层  
 
4.使用Subview的变数名称取得它在UIView中的索引值（Index ）。
￼
    NSInteger index = [[UIView subviews] indexOfObject:Subview名称];       //取得Index  
 
5.替Subview加上NSInteger 的註记(Tag)好让之后它们分辨彼此。
  ￼
    [Subview setTag:NSInteger];       //加上标记
    [UIView viewWithTag:NSInteger];  //通过标记得到view 返回值为UIView

6.最后是取得UIView中所有的Subview，呼叫此方法会传回一个 NSArray，并以由后往前的顺序列出这些 Subview，下图中是列出范例图片里Root中所有的Subview。
 ￼
    [UIView subviews] ;        //取的UIView下的所有Subview 

7.移到最上层或最下层
    将一个UIView显示在最前面只需要调用其父视图的 bringSubviewToFront（）方法。
    将一个UIView层推送到背后只需要调用其父视图的 sendSubviewToBack（）方法
###常用的方法

UIView : UIResponder
    /**
     *  通过一个frame来初始化一个UI控件
     */
    - (id)initWithFrame:(CGRect)frame;

    // YES:能够跟用户进行交互
    @property(nonatomic,getter=isUserInteractionEnabled) BOOL userInteractionEnabled;  // default is YES

    // 控件的一个标记(父控件可以通过tag找到对应的子控件)
    @property(nonatomic)                                 NSInteger tag;                // default is 0

    // 图层(可以用来设置圆角效果\阴影效果)
    @property(nonatomic,readonly,retain)                 CALayer  *layer;



    @interface UIView(UIViewGeometry)
    // 位置和尺寸(以父控件的左上角为坐标原点(0, 0))
    @property(nonatomic) CGRect            frame;

    // 位置和尺寸(以自己的左上角为坐标原点(0, 0))
    @property(nonatomic) CGRect            bounds;

    // 中点(以父控件的左上角为坐标原点(0, 0))
    @property(nonatomic) CGPoint           center;      

    // 形变属性(平移\缩放\旋转)
    @property(nonatomic) CGAffineTransform transform;   // default is CGAffineTransformIdentity

    // YES:支持多点触摸
    @property(nonatomic,getter=isMultipleTouchEnabled) BOOL multipleTouchEnabled;   // default is NO
    @end

    @interface UIView(UIViewHierarchy)
    // 父控件
    @property(nonatomic,readonly) UIView       *superview;

    // 子控件(新添加的控件默认都在subviews数组的后面, 新添加的控件默认都显示在最上面\最顶部)
    @property(nonatomic,readonly,copy) NSArray *subviews;

    // 获得当前控件所在的window
    @property(nonatomic,readonly) UIWindow     *window;

    // 从父控件中移除一个控件
    - (void)removeFromSuperview;

    // 添加一个子控件(可以将子控件插入到subviews数组中index这个位置)
    - (void)insertSubview:(UIView *)view atIndex:(NSInteger)index;

    // 交换subviews数组中所存放子控件的位置
    - (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2;

    // 添加一个子控件(新添加的控件默认都在subviews数组的后面, 新添加的控件默认都显示在最上面\最顶部)
    - (void)addSubview:(UIView *)view;

    // 添加一个子控件view(被挡在siblingSubview的下面)
    - (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;

    // 添加一个子控件view(盖在siblingSubview的上面)
    - (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;

    // 将某个子控件拉到最上面(最顶部)来显示
    - (void)bringSubviewToFront:(UIView *)view;

    // 将某个子控件拉到最下面(最底部)来显示
    - (void)sendSubviewToBack:(UIView *)view;

    /**系统自动调用(留给子类去实现)**/
    - (void)didAddSubview:(UIView *)subview;
    - (void)willRemoveSubview:(UIView *)subview;

    - (void)willMoveToSuperview:(UIView *)newSuperview;
    - (void)didMoveToSuperview;
    - (void)willMoveToWindow:(UIWindow *)newWindow;
    - (void)didMoveToWindow;
    /**系统自动调用**/

    // 是不是view的子控件或者子控件的子控件(是否为view的后代)
    - (BOOL)isDescendantOfView:(UIView *)view;  // returns YES for self.

    // 通过tag获得对应的子控件(也可以或者子控件的子控件)
    - (UIView *)viewWithTag:(NSInteger)tag;     // recursive search. includes self

    /**系统自动调用(留给子类去实现)**/
    // 控件的frame发生改变的时候就会调用,一般在这里重写布局子控件的位置和尺寸
    // 重写了这个写方法后,一定调用[super layoutSubviews];
    - (void)layoutSubviews;

    @end

    @interface UIView(UIViewRendering)
    // YES : 超出控件边框范围的内容都剪掉
    @property(nonatomic)                 BOOL              clipsToBounds;

    // 背景色
    @property(nonatomic,copy)            UIColor          *backgroundColor; // default is nil

    // 透明度(0.0~1.0)
    @property(nonatomic)                 CGFloat           alpha;                      // default is 1.0

    // YES:不透明  NO:透明
    @property(nonatomic,getter=isOpaque) BOOL              opaque;                     // default is YES

    // YES : 隐藏  NO : 显示
    @property(nonatomic,getter=isHidden) BOOL              hidden;

    // 内容模式
    @property(nonatomic)                 UIViewContentMode contentMode;                // default is UIViewContentModeScaleToFill
    @end
    //动画
    @interface UIView(UIViewAnimationWithBlocks)
    + (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
    + (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

    + (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations;
    + (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
    @end

#重点：UIView和CALayer的区别和联系
###1.首先UIView可以响应事件，Layer不可以.

UIKit使用UIResponder作为响应对象，来响应系统传递过来的事件并进行处理。UIApplication、UIViewController、UIView、和所有从UIView派生出来的UIKit类（包括UIWindow）都直接或间接地继承自UIResponder类。

在 UIResponder中定义了处理各种事件和事件传递的接口, 而 CALayer直接继承 NSObject，并没有相应的处理事件的接口。

下面列举一些处理触摸事件的接口

– touchesBegan:withEvent:
– touchesMoved:withEvent:
– touchesEnded:withEvent:
– touchesCancelled:withEvent:
其实还有一些运动和远程控制事件等等，这里就不一一列举了。

下面的两篇文章详细介绍了 iOS 事件的处理和传递

参考链接：
>http://blog.csdn.net/chun799/article/details/8223612
>http://yishuiliunian.gitbooks.io/implementate-tableview-to-understand-ios/content/uikit/1-1-2.html
###2.View和CALayer的Frame映射及View如何创建CALayer.

一个 Layer 的 frame 是由它的 anchorPoint,position,bounds,和 transform 共同决定的，而一个 View 的 frame 只是简单的返回 Layer的 frame，同样 View 的 center和 bounds 也是返回 Layer 的一些属性。（PS:center有些特列）为了证明这些，我做了如下的测试。

首先我自定义了两个类CustomView,CustomLayer分别继承 UIView 和 CALayer

在 CustomView 中重写了

+ (Class)layerClass
{
    return [CustomLayer class];
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}
- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
}
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
}
同样在 CustomLayer中同样重写这些方法。只是 setCenter方法改成setPosition方法

我在两个类的初始化方法中都打下了断点

blob.png

首先我们会发现，我们在 [view initWithFrame] 的时候调用私有方法【UIView _createLayerWithFrame】去创建 CALayer。

然后我在创建 View 的时候，在 Layer 和 View 中Frame 相关的所有方法中都加上断点，可以看到大致如下的调用顺序如下

[UIView _createLayerWithFrame]
[Layer setBounds:bounds]
[UIView setFrame：Frame]
[Layer setFrame:frame]
[Layer setPosition:position]
[Layer setBounds:bounds]
我发现在创建的过程只有调用了 Layer 的设置尺寸和位置的然而并没有调用View 的 SetCenter 和 SetBounds 方法。

然后我发现当我修改了 view的 bounds.size 或者 bounds.origin 的时候也只会调用上边 Layer的一些方法。所以我大胆的猜一下，View 的 Center 和 Bounds 只是直接返回layer 对应的 Position 和 Bounds.

View中frame getter方法，bounds和center，UIView并没有做什么工作；它只是简单的各自调用它底层的CALayer的frame，bounds和position方法。

关于 Frame 的理解参考：http://www.cocoachina.com/industry/20131209/7498.html

#(重点)3.UIView主要是对显示内容的管理而 CALayer 主要侧重显示内容的绘制。

我在 UIView 和 CALayer 分别重写了父类的方法。

[UIView drawRect:rect]//UIView    
[CALayer display]//CALayer
然后我在上面两个方法加了断点，可以看到如下的执行。

blob.png

可以看到 UIView 是 CALayer 的CALayerDelegate，我猜测是在代理方法内部[UIView(CALayerDelegate) drawLayer:inContext]调用 UIView 的 DrawRect方法，从而绘制出了 UIView 的内容.

###4.在做 iOS 动画的时候，修改非 RootLayer的属性（譬如位置、背景色等）会默认产生隐式动画，而修改UIView则不会。

对于每一个 UIView 都有一个 layer,把这个 layer 且称作RootLayer,而不是 View 的根 Layer的叫做 非 RootLayer。我们对UIView的属性修改时时不会产生默认动画，而对单独 layer属性直接修改会，这个默认动画的时间缺省值是0.25s.

在 Core Animation 编程指南的 “How to Animate Layer-Backed Views” 中，对为什么会这样做出了一个解释：

UIView 默认情况下禁止了 layer 动画，但是在 animation block 中又重新启用了它们

是因为任何可动画的 layer 属性改变时，layer 都会寻找并运行合适的 'action' 来实行这个改变。在 Core Animation 的专业术语中就把这样的动画统称为动作 (action，或者 CAAction)。

layer 通过向它的 delegate 发送 actionForLayer:forKey: 消息来询问提供一个对应属性变化的 action。delegate 可以通过返回以下三者之一来进行响应：

它可以返回一个动作对象，这种情况下 layer 将使用这个动作。
它可以返回一个 nil， 这样 layer 就会到其他地方继续寻找。
它可以返回一个 NSNull 对象，告诉 layer 这里不需要执行一个动作，搜索也会就此停止。
当 layer 在背后支持一个 view 的时候，view 就是它的 delegate；

这部分的具体内容参考：http://objccn.io/issue-12-4/

###总结

总接来说就是如下几点：

每个 UIView 内部都有一个 CALayer 在背后提供内容的绘制和显示，并且 UIView 的尺寸样式都由内部的 Layer 所提供。两者都有树状层级结构，layer 内部有 SubLayers，View 内部有 SubViews.但是 Layer 比 View 多了个AnchorPoint
在 View显示的时候，UIView 做为 Layer 的 CALayerDelegate,View 的显示内容由内部的 CALayer 的 display
CALayer 是默认修改属性支持隐式动画的，在给 UIView 的 Layer 做动画的时候，View 作为 Layer 的代理，Layer 通过 actionForLayer:forKey:向 View请求相应的 action(动画行为)
layer 内部维护着三分 layer tree,分别是 presentLayer Tree(动画树),modeLayer Tree(模型树), Render Tree (渲染树),在做 iOS动画的时候，我们修改动画的属性，在动画的其实是 Layer 的 presentLayer的属性值,而最终展示在界面上的其实是提供 View的modelLayer
两者最明显的区别是 View可以接受并处理事件，而 Layer 不可以
参考链接
>http://blog.csdn.net/weiwangchao_/article/details/7771538



