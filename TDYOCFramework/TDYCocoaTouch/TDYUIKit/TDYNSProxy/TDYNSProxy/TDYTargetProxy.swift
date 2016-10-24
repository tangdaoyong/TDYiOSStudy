//
//  TDYTargetProxy.swift
//  TDYNSProxy
//
//  Created by 唐道勇 on 16/10/22.
//  Copyright © 2016年 唐道勇. All rights reserved.
//

import Cocoa

class TDYTargetProxy: NSProxy {
    
    var my_realObjectOne:AnyClass!
    var my_realObjectTwo:AnyClass!
    //MARK - 自己写的方法
    func initWithTarget(targetOne:AnyClass, targetTwo:AnyClass) -> NSProxy {
        my_realObjectOne = targetOne
        my_realObjectTwo = targetTwo
        return self;
    }
    /*
    //unavailable NSInvocation and related APIs not available。NSInvocation和API在swift中不可用
    override func forwardInvocation(_ invocation: NSInvocation){
        var my_target = my_realObjectOne.method(for: invocation.selector ? my_realObjectOne: my_realObjectTwo)
        //invocation.
    }
    */
    open func method(for aSelector: Selector!) -> IMP!{
        var my_NSMethodSignature:IMP!
        my_NSMethodSignature = my_realObjectOne.method(for: aSelector)
        if (my_NSMethodSignature != nil) {
            return my_NSMethodSignature
        }
        my_NSMethodSignature = my_realObjectTwo.method(for: aSelector)
        return my_NSMethodSignature
    }
    
    override func responds(to aSelector: Selector) -> Bool{
        if (my_realObjectOne.responds(to: aSelector)) {
            return true
        }
        if (my_realObjectTwo.responds(to: aSelector)) {
            return true
        }
        return false
    }
}
