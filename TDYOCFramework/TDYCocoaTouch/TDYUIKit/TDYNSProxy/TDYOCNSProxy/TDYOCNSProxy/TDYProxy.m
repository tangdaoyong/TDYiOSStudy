//
//  TDYProxy.m
//  TDYNSProxy
//
//  Created by 唐道勇 on 16/10/22.
//  Copyright © 2016年 唐道勇. All rights reserved.
//

#import "TDYProxy.h"

@interface TDYProxy ()

@property (nonatomic, strong) id my_realObjectOne;
@property (nonatomic, strong) id my_realObjectTwo;

@end

@implementation TDYProxy

/**向外暴露的的方法*/
- (id)initWithTarget:(id)targetOne andTargetTwo:(id)targetTwo{
    self.my_realObjectOne = targetOne;
    self.my_realObjectTwo = targetTwo;
    return self;
}
#pragma mark 继承的方法
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    NSMethodSignature *my_sig;
    my_sig = [self.my_realObjectOne methodSignatureForSelector:sel];
    if (my_sig) {
        return my_sig;
    }
    my_sig = [self.my_realObjectTwo methodSignatureForSelector:sel];
    return my_sig;
}
- (void)forwardInvocation:(NSInvocation *)invocation{
    id target = [self.my_realObjectOne methodSignatureForSelector:[invocation selector]] ? self.my_realObjectOne:self.my_realObjectTwo;
    [invocation invokeWithTarget:target];
}
- (BOOL)respondsToSelector:(SEL)aSelector{
    if ([self.my_realObjectOne respondsToSelector:aSelector]) {
        return YES;
    }
    if ([self.my_realObjectTwo respondsToSelector:aSelector]) {
        return YES;
    }
    return NO;
}

@end
