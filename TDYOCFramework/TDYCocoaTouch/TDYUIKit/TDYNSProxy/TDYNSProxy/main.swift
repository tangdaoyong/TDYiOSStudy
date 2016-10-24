//
//  main.swift
//  TDYNSProxy
//
//  Created by 唐道勇 on 16/10/22.
//  Copyright © 2016年 唐道勇. All rights reserved.
//

import Foundation

print("Hello, World!")
var proxy:TDYObject = TDYObject()
proxy.tdy_proxy()
/**
 *在swift中，不能调用没有的方法，OC中有运行时机制。
 **/
//var proxy:TDYProxy = TDYProxy.init(target: NSString(), andTargetTwo: NSArray())
