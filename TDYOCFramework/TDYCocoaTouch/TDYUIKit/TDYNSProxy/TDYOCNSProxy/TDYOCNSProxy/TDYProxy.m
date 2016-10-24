//
//  TDYProxy.m
//  TDYNSProxy
//
//  Created by 唐道勇 on 16/10/22.
//  Copyright © 2016年 唐道勇. All rights reserved.
//

#import "TDYProxy.h"

@interface TDYProxy ()

//@property (nonatomic, strong) id my_realObjectOne;
//@property (nonatomic, strong) id my_realObjectTwo;

@end

@implementation TDYProxy{
    id my_realObjectOne;
    id my_realObjectTwo;
}

/**向外暴露的的方法*/
- (id)initWithTarget:(id)targetOne andTargetTwo:(id)targetTwo{
    my_realObjectOne = targetOne;
    my_realObjectTwo = targetTwo;
    return self;
}
#pragma mark 继承的方法
/*判断传入的实例是否可以处理*/
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    NSMethodSignature *my_sig = nil;
    my_sig = [my_realObjectOne methodSignatureForSelector:sel];
    if (my_sig) {
        return my_sig;
    }
    my_sig = [my_realObjectTwo methodSignatureForSelector:sel];
    return my_sig;
}
/**/
- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL tdy = [invocation selector];
    id target = [my_realObjectOne methodSignatureForSelector:[invocation selector]] ? my_realObjectOne:my_realObjectTwo;
    [invocation invokeWithTarget:target];
}
/*最好是从写下面的方法，这样可以在其他地方查看是否支持方法*/
- (BOOL)respondsToSelector:(SEL)aSelector{
    if ([my_realObjectOne respondsToSelector:aSelector]) {
        return YES;
    }
    if ([my_realObjectTwo respondsToSelector:aSelector]) {
        return YES;
    }
    return NO;
}

@end
