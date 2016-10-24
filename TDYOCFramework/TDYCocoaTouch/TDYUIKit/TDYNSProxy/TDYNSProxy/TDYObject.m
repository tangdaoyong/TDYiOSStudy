//
//  TDYObject.m
//  TDYNSProxy
//
//  Created by 唐道勇 on 16/10/22.
//  Copyright © 2016年 唐道勇. All rights reserved.
//

#import "TDYObject.h"
#import "TDYProxy.h"

@implementation TDYObject

- (void) tdy_proxy{
    id proxy = [[TDYProxy alloc] initWithTarget:[[NSMutableString alloc] init] andTargetTwo:[[NSMutableArray alloc] init]];
    
    // Note that we can't use appendFormat:, because vararg methods
    // cannot be forwarded!
    [proxy appendString:@"This "];
    [proxy appendString:@"is "];
    [proxy addObject:@"myString"];
    [proxy appendString:@"a "];
    [proxy appendString:@"test!"];
    
    if ([[proxy objectAtIndex:0] isEqualToString:@"This is a test!"]) {
        NSLog(@"Appending successful.");
    } else {
        NSLog(@"Appending failed, got: '%@'", proxy);
    }
}

@end
