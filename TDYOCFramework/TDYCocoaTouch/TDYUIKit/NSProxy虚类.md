#NSProxy(虚类)
NSProxy是除了NSObject之外的另外一个基础类。
总的来说，NSProxy是一个虚类，你可以通过继承它，并重写这两个方法以实现消息转发到另一个实例:

    - (void)forwardInvocation:(NSInvocation *)invocation;
    - (NSMethodSignature *)methodSignatureForSelector:(SEL)sel ;
现在NSProxy的真面目终于浮出水面：负责将消息转发到真正的target的代理类。举个例子，你想要卖一件二手物品，但是你并不想直接跟卖家接触（直接向target发消息），这时你去找了一个第三方，你告诉这个第三方你要买什么、出多少钱买、什么时候要等（向代理发消息），第三方再去跟卖家接触并把这些信息转告卖家（转发消息给真实的target），最后通过第三方去完成这个交易。
###概念
在obj-c中我们可以向一个实例发送消息，相当于c/c++ java中的方法调用，只不过在这儿是说发送消息，实例收到消息后会进行一些处理。比如我们想调用一个方法，便向这个实例发送一个消息，实例收到消息后，如果能respondsToSelector，那么就会调用相应的方法。如果不能respond一般情况下会crash。今天要的，就是不让它crash。
首先说一下向一个实例发送一个消息后，系统是处理的流程：

    1. 发送消息如：[self startwork]
    2. 系统会check是否能response这个消息
    3. 如果能response则调用相应方法，不能则抛出异常

在第二步中，系统是如何check实例是否能response消息呢？如果实例本身就有相应的response,那么就会相应之，如果没有系统就会发出methodSignatureForSelector消息，寻问它这个消息是否有效？有效就返回对应的方法地址之类的，无效则返回nil。如果是nil就会crash， 如果不是nil接着发送forwardInvocation消息。
所以我们在重写methodSignatureForSelector的时候就人工让其返回有效实例。
###实现
我们定义了这样一个类

    @interface TargetProxy : NSProxy {    
        id realObject1;    
        id realObject2;    
    }    

    - (id)initWithTarget1:(id)t1 target2:(id)t2;    
     
    @end
实现

    @implementation TargetProxy    

    - (id)initWithTarget1:(id)t1 target2:(id)t2 {    
        realObject1 = [t1 retain];    
        realObject2 = [t2 retain];    
        return self;    
    }    

    - (void)dealloc {    
        [realObject1 release];    
        [realObject2 release];    
        [super dealloc];    
    }    

    // The compiler knows the types at the call site but unfortunately doesn't    
    // leave them around for us to use, so we must poke around and find the types    
    // so that the invocation can be initialized from the stack frame.    

    // Here, we ask the two real objects, realObject1 first, for their method    
    // signatures, since we'll be forwarding the message to one or the other    
    // of them in -forwardInvocation:.  If realObject1 returns a non-nil    
    // method signature, we use that, so in effect it has priority.    
    - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {    
        NSMethodSignature *sig;    
        sig = [realObject1 methodSignatureForSelector:aSelector];    
        if (sig) return sig;    
        sig = [realObject2 methodSignatureForSelector:aSelector];    
        return sig;    
    }    

    // Invoke the invocation on whichever real object had a signature for it.    
    - (void)forwardInvocation:(NSInvocation *)invocation {    
        id target = [realObject1 methodSignatureForSelector:[invocation selector]] ? realObject1 : realObject2;    
        [invocation invokeWithTarget:target];    
    }    

    // Override some of NSProxy's implementations to forward them...    
    - (BOOL)respondsToSelector:(SEL)aSelector {    
        if ([realObject1 respondsToSelector:aSelector]) return YES;    
        if ([realObject2 respondsToSelector:aSelector]) return YES;    
        return NO;    
    }    

    @end  
现在我们还用这个类，注意向它发送的消息：

    id proxy = [[TargetProxy alloc] initWithTarget1:string target2:array];    

      // Note that we can't use appendFormat:, because vararg methods    
      // cannot be forwarded!    
      [proxy appendString:@"This "];    
      [proxy appendString:@"is "];    
      [proxy addObject:string];    
      [proxy appendString:@"a "];    
      [proxy appendString:@"test!"];    

      NSLog(@"count should be 1, it is: %d", [proxy count]);    

      if ([[proxy objectAtIndex:0] isEqualToString:@"This is a test!"]) {    
          NSLog(@"Appending successful.");    
      } else {    
          NSLog(@"Appending failed, got: '%@'", proxy);    
      }  
运行的结果是：
count should be 1, it is:  1
Appending successful.
TargetProxy声明中是没有appendString与addObject消息的，在这儿却可以正常发送，不crash，原因就是发送消息的时候，如果原本类没有这个消息响应的时候，转向询问methodSignatureForSelector，接着在forwardInvocation将消息重定向。
>参考自：http://blog.csdn.net/zhouleizhao/article/details/37878727
###通过NSProxy在Objective-C中模拟多继承
多继承在编程中可以说是比较有用的特性。举个例子，原本有两个相互独立的类A和类B，它们各自继承各自的父类，项目进行地好好的，突然有一天产品经理过来告诉你，我要在下个版本加一个xxxxx的特性，非常紧急。一脸懵逼的你发现如果要实现这个特性，你需要对类A以及其父类作很大的修改，代价非常之高。突然你意识到原来类B的父类已经有类似的功能，你只需要让类A继承于类B的父类并重写其某些方法就能实现，这样做高效且低风险，于是你屁颠屁颠地撸起了代码。

可是，Objective-C却不支持这样一个强大的特性。不过NSProxy可以帮我们在某种程度上（这只是一个模拟的多继承，并不是完全的多继承）解决这个问题：

现在假设我们想要去买书，但是我懒癌犯了，不想直接去书店（供应商）买，如果有一个跑腿的人（经销商）帮我去书店买完，我再跟他买。同时，我买完书又想买件衣服，我又可以很轻松地在他那里买到一件衣服（多继承）。

首先，我们定义BookProvider类与ClothesProvider类作为基类。
TDBookProvider

    // TDBookProvider.h
    #import 

    @protocol TDBookProviderProtocol 
    - (void)purchaseBookWithTitle:(NSString *)bookTitle;
    @end

    @interface TDBookProvider : NSObject
    @end

    // TDBookProvider.m
    #import "TDBookProvider.h" 
    @interface TDBookProvider () 
    @end
    @implementation TDBookProvider

    - (void)purchaseBookWithTitle:(NSString *)bookTitle{
        NSLog(@"You've bought \"%@\"",bookTitle);
    }
    @end
    TDClothesProvider.h
    //  TDClothesProvider.h

    #import

    typedef NS_ENUM (NSInteger, TDClothesSize){
        TDClothesSizeSmall = 0,
        TDClothesSizeMedium,
        TDClothesSizeLarge
    };

    @protocol TDClothesProviderProtocol 

    - (void)purchaseClothesWithSize:(TDClothesSize )size;

    @end

    @interface TDClothesProvider : NSObject

    @end
#####TDClothesProvider

    //  TDClothesProvider.m

    #import "TDClothesProvider.h"

    @interface TDClothesProvider () 

    @end

    @implementation TDClothesProvider

    - (void)purchaseClothesWithSize:(TDClothesSize )size{
        NSString *sizeStr;
        switch (size) {
            case TDClothesSizeLarge:
                sizeStr = @"large size";
                break;
            case TDClothesSizeMedium:
                sizeStr = @"medium size";
                break;
            case TDClothesSizeSmall:
                sizeStr = @"small size";
                break;
            default:
                break;
        }
        NSLog(@"You've bought some clothes of %@",sizeStr);
    }
    @end
这里要注意：一定要通过protocol来声明接口，而不是直接在类的@interfere中定义。因为通过protocol来声明接口，然后让proxy类遵循此协议，可以骗过编译器防止编译器提示proxy类未声明接口的错误。这个问题下面可以看到。
现在两个Provider的类写完，我们可以直接向供应商买东西了，但这跟我们的需求还有很大差异，我们需要一个中间的经销商

    //  TDDealerProxy.h

    #import 
    #import "TDBookProvider.h"
    #import "TDClothesProvider.h"

    @interface TDDealerProxy : NSProxy 

    + (instancetype )dealerProxy;

    @end

    //  TDDealerProxy.m

    #import "TDDealerProxy.h"
    #import <objc/runtime.h>

    @interface TDDealerProxy () {
        TDBookProvider          *_bookProvider;
        TDClothesProvider       *_clothesProvider;
        NSMutableDictionary     *_methodsMap;
    }
    @end

    @implementation TDDealerProxy

    #pragma mark - class method
    + (instancetype)dealerProxy{
        return [[TDDealerProxy alloc] init];
    }

    #pragma mark - init
    - (instancetype)init{
        _methodsMap = [NSMutableDictionary dictionary];
        _bookProvider = [[TDBookProvider alloc] init];
        _clothesProvider = [[TDClothesProvider alloc] init];

        //映射target及其对应方法名
        [self _registerMethodsWithTarget:_bookProvider];
        [self _registerMethodsWithTarget:_clothesProvider];

        return self;
    }

    #pragma mark - private method
    - (void)_registerMethodsWithTarget:(id )target{

        unsigned int numberOfMethods = 0;

        //获取target方法列表
        Method *method_list = class_copyMethodList([target class],&numberOfMethods);

        for (int i = 0; i < numberOfMethods; i ++) {
            //获取方法名并存入字典
            Method temp_method = method_list[i];
            SEL temp_sel = method_getName(temp_method);
            const char *temp_method_name = sel_getName(temp_sel);
            [_methodsMap setObject:target forKey:[NSString stringWithUTF8String:temp_method_name]];
        }

        free(method_list);
    }
    #pragma mark - NSProxy override methods
    - (void)forwardInvocation:(NSInvocation *)invocation{
        //获取当前选择子
        SEL sel = invocation.selector;

        //获取选择子方法名
        NSString *methodName = NSStringFromSelector(sel);

        //在字典中查找对应的target
        id target = _methodsMap[methodName];

        //检查target
        if (target && [target respondsToSelector:sel]) {
            [invocation invokeWithTarget:target];
        } else {
            [super forwardInvocation:invocation];
        }
    }

    - (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
        //获取选择子方法名
        NSString *methodName = NSStringFromSelector(sel);

        //在字典中查找对应的target
        id target = _methodsMap[methodName];

        //检查target
        if (target && [target respondsToSelector:sel]) {
            return [target methodSignatureForSelector:sel];
        } else {
            return [super methodSignatureForSelector:sel];
        }
    }

    @end
这里有两个要注意的问题：1、TDDealerProxy这个子类必须要遵循之前定义的两个协议TDBookProviderProtocol与TDClothesProviderProtocol，目的是骗过编译器，让编译器认为这个类实现了上面两个协议2、NSProxy类是没有init方法的，也就是说如果我们要获得一个NSProxy的实例，代码只需要这样：

    NSProxy *proxyInstance = [NSProxy alloc];
在AppDelagate 中 实现:

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

        TDDealerProxy *dealerProxy = [TDDealerProxy dealerProxy];
        [dealerProxy purchaseBookWithTitle:@"Swift 100 Tips"];
        [dealerProxy purchaseClothesWithSize:TDClothesSizeMedium];

        // Override point for customization after application launch.
        return YES;
    }

文／zcaaron（简书作者）
原文链接：http://www.jianshu.com/p/8d42cc3a6296
著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。