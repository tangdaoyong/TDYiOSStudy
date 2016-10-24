//
//  main.m
//  TDYOCNSProxy
//
//  Created by 唐道勇 on 16/10/23.
//  Copyright © 2016年 唐道勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDYProxy.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        id proxy = [[TDYProxy alloc] initWithTarget:[[NSMutableString alloc] init] andTargetTwo:[[NSMutableArray alloc] init]];
        
        // Note that we can't use appendFormat:, because vararg methods
        // cannot be forwarded!
        [proxy appendString:@"This "];
        [proxy appendString:@"is "];
        [proxy addObject:@"myString"];//只有addObject添加进去了的。感觉NSProxy可以像数组一样操作。
        [proxy appendString:@"a "];
        [proxy appendString:@"test!"];
        [proxy addObject:@"tangdaoyong"];
        
        //NSLog(@"count should be 1, it is: %d", proxy.count);
        NSLog(@"====%@===", [proxy objectAtIndex:1]);
        if ([[proxy objectAtIndex:0] isEqualToString:@"This is a test!"]) {
            NSLog(@"Appending successful.");
        } else {
            NSLog(@"Appending failed, got: '%@'", proxy);
        }
        for (id string in [proxy reverseObjectEnumerator]) {
            NSLog(@"str = %@", NSStringFromClass([string class]));
        }

    }
    return 0;
}
