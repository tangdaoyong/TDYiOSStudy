//
//  ViewController.m
//  TDYIOS9StackView
//
//  Created by 唐道勇 on 16/10/13.
//  Copyright © 2016年 唐道勇. All rights reserved.
//
/*
 UIStackView的 代码使用
 */
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //主
    UIStackView *myStackView = [[UIStackView alloc] initWithFrame:CGRectMake(50, 400, 300, 50)];
    myStackView.axis = UILayoutConstraintAxisHorizontal;//水平
    //myStackView.distribution = UIStackViewDistributionEqualSpacing;
    myStackView.spacing = 10;
    [self.view addSubview:myStackView];
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    myView.backgroundColor = [UIColor redColor];
    [myStackView addArrangedSubview:myView];
    
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    NSLog(@"lableFrame:%f,%f", Label.frame.size.width, Label.frame.size.height);
    Label.text = @"我是lable";//必须要设置不然显示不出来
    Label.backgroundColor = [UIColor blueColor];
    [myStackView addArrangedSubview:Label];

    //子
    UIStackView *myStackViewSub = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    myStackViewSub.axis = UILayoutConstraintAxisVertical;//竖着
    myStackViewSub.alignment = UIStackViewAlignmentCenter;//对齐
    //[myStackView addArrangedSubview:myStackViewSub];
    
    UIImageView *myImageViewsub = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    myImageViewsub.backgroundColor = [UIColor blackColor];
    [myStackViewSub addArrangedSubview:myImageViewsub];
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    myLabel.text = @"我是子leble";
    myLabel.backgroundColor = [UIColor blueColor];
    [myStackViewSub addArrangedSubview:myLabel];
    
    [myStackView addArrangedSubview:myStackViewSub];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
