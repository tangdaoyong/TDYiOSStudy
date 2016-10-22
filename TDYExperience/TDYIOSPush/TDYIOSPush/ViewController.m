//
//  ViewController.m
//  TDYIOSPush
//
//  Created by 唐道勇 on 16/10/14.
//  Copyright © 2016年 唐道勇. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

//打印输出(定位)
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d  \t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

NSString *requestIdentifier = @"sampleRequest";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    NSLog(@"进入了ViewController页面");
    // Do any additional setup after loading the view, typically from a nib.
    //Content以前只能展示一条文字，现在可以有 title 、subtitle 以及 body 了。现在可以定制了，如下：
    //Local Notification本地推送
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Introduction to Notifications";
    content.subtitle = @"Session 707";
    content.body = @"唐道勇Woah! These new notifications look amazing! Don’t you agree?";
    content.badge = @1;//The application badge number. nil means no change. 0 to hide.徽章数，没有和0表示没有改变
    content.sound = [UNNotificationSound soundNamed:@"japanese.mp3"];
    
    /*
    //Remote Notification远程推送
    {
        "aps" : {
            "alert" : {
                "title" : "Introduction to Notifications",
                "subtitle" : "Session 707",
                "body" : "Woah! These new notifications look amazing! Don’t you agree?"
            },
            "badge" : 1
        },
    }
     */
    
    /*触发方式
     Triggers又是一个新的功能，有三种
     UNTimeIntervalNotificationTrigger
     UNCalendarNotificationTrigger
     UNLocationNotificationTrigger
     iOS 10触发器有4种
     •UNPushNotificationTrigger 触发APNS服务，系统自动设置（这是区分本地通知和远程通知的标识）
     •UNTimeIntervalNotificationTrigger 一段时间后触发
     •UNCalendarNotificationTrigger 指定日期触发
     •UNLocationNotificationTrigger 根据位置触发，支持进入某地或者离开某地或者都有
     */
    //2 分钟后提醒
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    //每小时重复 1 次喊我喝水(UNTimeIntervalNotificationTrigger可以安排在设备上通知的时间间隔后,和可选地重复。)
    //UNTimeIntervalNotificationTrigger *trigger2 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:YES];//yes循环
    
    //每周一早上 8：00 提醒我给老婆做早饭
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekday = 2;
    components.hour = 8;
    UNCalendarNotificationTrigger *trigger3 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    //#import <CoreLocation/CoreLocation.h>
    //一到麦当劳就喊我下车
    //CLRegion *region = [[CLRegion alloc] init];
    //UNLocationNotificationTrigger *trigger4 = [UNLocationNotificationTrigger triggerWithRegion:region repeats:NO];
    //添加Request
    //NSString *requestIdentifier = @"sampleRequest";
    //static int number = 0;
    //将前面的内容和触发时间添加进来如：content和trigger1
    /*
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"number%d", number]//requestIdentifier
                                                                          content:content
                                                                          trigger:trigger1];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"number = %d", number);
        number++;
    }];
     */
    /*刷新推送
     Local Notification 通过更新 request
     Remote Notification 通过新的字段 apns-collapse-id
     通过之前的 addNotificationRequest: 方法，在 id 不变的情况下重新添加，就可以刷新原有的推送。
     
     NSString *requestIdentifier = @"sampleRequest";
     UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
     content:newContent
     trigger:newTrigger1];
     [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
     
     }];
     */
    //定时器
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(tdy_timer:) userInfo:@[content, trigger1] repeats:YES];
    
    //添加一个button用于取消一个通知
    UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 60)];
    [myButton setTitle:@"取消通知" forState:UIControlStateNormal];
    myButton.backgroundColor = [UIColor redColor];
    [myButton addTarget:self action:@selector(tdy_cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myButton];
}
//定时器
- (void) tdy_timer:(NSTimer *)myTimer{
    static int number = 1;
    
    UNMutableNotificationContent *content = myTimer.userInfo[0];
    content.subtitle = [NSString stringWithFormat:@"Session %d", number];
    content.badge = @(number);
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:/*[NSString stringWithFormat:@"number%d", number]*/requestIdentifier
                                                                          content:content
                                                                          trigger:myTimer.userInfo[1]];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"number = %d", number);
    }];
    
    number++;
}
//取消推送通知
- (void) tdy_cancelButton:(UIButton *) sender{
    /*
     Pending 等待触发的通知
     •Delivered 已经触发展示在通知中心的通知
     //获取未触发的通知
     [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
     NSLog(@"pending: %@", requests);
     }];
     
     //获取通知中心列表的通知
     [[UNUserNotificationCenter currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
     NSLog(@"Delivered: %@", notifications);
     }];
     
     //清除某一个未触发的通知
     [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[@"TestRequest1"]];
     //清除某一个通知中心的通知
     [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[@"TestRequest2"]];
     //对应的删除所有通知
     [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
     [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
     */
    [sender setTitle:@"取消成功" forState:UIControlStateNormal];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:@[requestIdentifier]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
