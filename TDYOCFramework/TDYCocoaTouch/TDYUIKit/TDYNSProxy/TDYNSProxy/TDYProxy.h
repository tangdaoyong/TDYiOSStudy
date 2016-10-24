//
//  TDYProxy.h
//  TDYNSProxy
//
//  Created by 唐道勇 on 16/10/22.
//  Copyright © 2016年 唐道勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDYProxy : NSProxy

/**向外暴露的的方法*/
- (id)initWithTarget:(id)targetOne andTargetTwo:(id)targetTwo;

@end
