//
//  AppDelegate.m
//  TDYIOSPush
//
//  Created by 唐道勇 on 16/10/14.
//  Copyright © 2016年 唐道勇. All rights reserved.
//
/*
 本工程介绍ios的本地推送。
 在iOS8之后，以前的本地推送写法可能会出错，接收不到推送的信息。
 在IOS8下没有注册，所以需要额外添加对IOS8的注册方法，API中有下面这个方法：
 - (void)registerUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings NS_AVAILABLE_IOS(8_0);
 iOS 10 以前的推送服务。
 iOS 推送分为 Local Notifications（本地推送） 和 Remote Notifications（远程推送）
 
 iOS10之后要使用UserNotifications Framework框架了。
 Local Notifications 通过定义 Content 和 Trigger 向 UNUserNotificationCenter 进行 request 这三部曲来实现。
 Remote Notifications 则向 APNs 发送 Notification Payload 。
 */
#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>//引入推送框架

//判断版本
#define IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

@interface AppDelegate ()<UNUserNotificationCenterDelegate>//通过实现协议，使 App 处于前台时捕捉并处理即将触发的推送：

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*
     //iOS8以下
     [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
     
     //iOS8 - iOS10
     [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
     
     //iOS10
     UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
     [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
         if (granted) {
         //点击允许
         NSLog(@"注册通知成功");
         [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
         NSLog(@"%@", settings);
         }];
         } else {
         //点击不允许
         NSLog(@"注册通知失败");
         }
     }
     */
    if (!IOS10_OR_LATER) {
        //注册推送
        //iOS 10 以前
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        /*
         IOS8以后需要注册通知类型,包含哪些(声音,图标文字,)信息,
         UIUserNotificationTypeNone    = 0
         UIUserNotificationTypeBadge   = 1 << 0 包含图标文字(左上角的数字)0001
         UIUserNotificationTypeSound   = 1 << 1 声音 ----------------->0010
         UIUserNotificationTypeAlert   = 1 << 2 主题内容--------------->0100
         目前是:0111,这个值是数值,下面的|||之间的内容相当于数值
         */

    }
    
    //iOS 10 以后
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
    // Override point for customization after application launch.
    //ios10可以得到用户更加详细的设定信息
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"=================%@",settings);
    }];
    //Token Registration注册
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 本地推送
/*
 <UNUserNotificationCenterDelegate>
 iOS10收到通知不再是在application: didReceiveRemoteNotification:方法去处理， iOS10推出新的代理方法，接收和处理各类通知（本地或者远程）
 -(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
 
 completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);//让它只显示 alert 和 sound ,而忽略 badge 。
 }
 */
//推送协议（设置支持的推送内容）

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    //应用在前台收到通知
    NSLog(@"应用在前台收到通知========%@", notification);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    //点击通知进入应用
    NSLog(@"点击通知进入应用response:%@", response);
}

@end
