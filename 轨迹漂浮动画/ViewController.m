//
//  ViewController.m
//  轨迹漂浮动画
//
//  Created by wyb on 2017/5/22.
//  Copyright © 2017年 中天易观. All rights reserved.
//

#import "ViewController.h"
#import "LikeAnimationLayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(show)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)show
{
    LikeAnimationLayer *likeLayer = [[LikeAnimationLayer alloc]initWithSuperView:self.view];
    likeLayer.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - 100);
    [likeLayer addAnimation];
    [self.view.layer addSublayer:likeLayer];
}




@end
