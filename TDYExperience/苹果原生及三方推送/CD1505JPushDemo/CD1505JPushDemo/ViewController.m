//
//  ViewController.m
//  CD1505JPushDemo
//
//  Created by HeHui on 16/1/15.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import "ViewController.h"
#import "JPUSHService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    [JPUSHService setBadge:0];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)test:(id)sender {
    
    
       
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
