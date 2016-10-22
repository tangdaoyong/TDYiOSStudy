//
//  AppDelegate.m
//  CD1505JPushDemo
//
//  Created by HeHui on 16/1/15.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 应用注册极光推送
    [self rgeisterWithOptions:launchOptions];
    // Override point for customization after application launch.
    return YES;
}

- (void)rgeisterWithOptions:(NSDictionary *)launchOptions
{
    [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound  categories:nil];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"852b539116d8dbf02c2ea757" channel:@"1" apsForProduction:NO];
    
}

// 获取设备的deviceToken(设备标识符 ***不是UDID)
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 将token交给极光服务器，极光根据这个deviceToken就可以确定我们的设备
    [JPUSHService registerDeviceToken:deviceToken];
}

// 接受到远程推送之后的回调方法 （IOS 7以前）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 极光推送处理收到远程推送的操作
    [JPUSHService handleRemoteNotification:userInfo];
}

// 是接受到远程推送之后的回调方法 （IOS 7以后）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"userInfo = %@",userInfo);
    
    UIViewController *vc = [[UIViewController alloc] init];
    
    if ([userInfo[@"color"] isEqualToString:@"red"]) {
        vc.view.backgroundColor = [UIColor redColor];
    }else if([userInfo[@"color"] isEqualToString:@"blue"]){
        vc.view.backgroundColor = [UIColor blueColor];
    }
    
    self.window.rootViewController = vc;
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    
//    UILocalNotification *locNotice = [JPUSHService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:10] alertBody:@"可以吃放了" badge:1 alertAction:@"知道了" identifierKey:@"id01" userInfo:@{@"key":@"xxxxx"} soundName:@"smsg.mp3" region:nil regionTriggersOnce:NO category:nil];
    
    
    UILocalNotification *locNotice = [JPUSHService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:10] alertBody:@"干哈呢" badge:0 alertAction:@"别烦" identifierKey:@"id02" userInfo:userInfo soundName:@"smsg.mp3"];
    
    
    [JPUSHService showLocalNotificationAtFront:locNotice identifierKey:@"id02"];

}

// 注册远程推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}



@end
